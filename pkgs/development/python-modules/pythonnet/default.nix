{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pycparser
, psutil
, dotnet-sdk
, buildDotnetModule
, clr-loader
, setuptools
}:

let
  pname = "pythonnet";
  version = "3.0.1";
  src = fetchPypi {
    pname = "pythonnet";
    inherit version;
    sha256 = "sha256-7U9/f5VRVAQRLds9oWOOGhATy1bmTEjE+mAwPwKwo90=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    nugetDeps = ./deps.nix;
  };
in
buildPythonPackage {
  inherit pname version src;

  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
    dotnet-sdk
  ];

  propagatedBuildInputs = [
    pycparser
    clr-loader
  ];

  pytestFlagsArray = [
    # Run tests using .NET Core, Mono is unsupported for now due to find_library problem in clr-loader
    "--runtime coreclr"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil # needed for memory leak tests
  ];

  # Perform dotnet restore based on the nuget-source
  preConfigure = ''
    dotnet restore \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      --source ${dotnet-build.nuget-source}
  '';

  # Rerun this when updating to refresh Nuget dependencies
  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = with lib; {
    description = ".NET integration for Python";
    homepage = "https://pythonnet.github.io";
    license = licenses.mit;
    # <https://github.com/pythonnet/pythonnet/issues/898>
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ jraygauthier mdarocha ];
  };
}
