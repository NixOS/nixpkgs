{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, dotnetCorePackages
, setuptools
, buildDotnetModule
, cffi
}:

let
  pname = "clr_loader";
  version = "0.2.5";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gu1ftlRynRT9iCludLtrhOss+5dv9LfUnU5En9eKIms=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    projectFile = [ "netfx_loader/ClrLoader.csproj" "example/example.csproj" ];
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
    dotnetCorePackages.sdk_6_0
  ];

  propagatedBuildInputs = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # TODO: mono does not work due to https://github.com/NixOS/nixpkgs/issues/7307
    "test_mono"
    "test_mono_debug"
    "test_mono_signal_chaining"
    "test_mono_set_dir"
  ];

  # Perform dotnet restore based on the nuget-source
  preConfigure = ''
    dotnet restore "netfx_loader/ClrLoader.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      --source "${dotnet-build.nuget-source}"

    dotnet restore "example/example.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true \
      --source "${dotnet-build.nuget-source}"
  '';

  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = with lib; {
    description = "Generic pure Python loader for .NET runtimes";
    homepage = "https://pythonnet.github.io/clr-loader/";
    license = licenses.mit;
    maintainers = with maintainers; [ mdarocha ];
  };
}
