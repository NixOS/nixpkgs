{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pycparser,
  psutil,
  dotnet-sdk_6,
  buildDotnetModule,
  clr-loader,
  setuptools,
}:

let
  pname = "pythonnet";
  version = "3.0.4";
  src = fetchFromGitHub {
    owner = "pythonnet";
    repo = "pythonnet";
    rev = "v${version}";
    hash = "sha256-QdgcBFQDFxmFxuXsDlHcu+L/VWw2aKfyWDqPrawyhOs=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    projectFile = "src/runtime/Python.Runtime.csproj";
    testProjectFile = "src/testing/Python.Test.csproj";
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

  buildInputs = dotnet-build.nugetDeps;

  nativeBuildInputs = [
    setuptools
    dotnet-sdk_6
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

  # Rerun this when updating to refresh Nuget dependencies
  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = with lib; {
    description = ".NET integration for Python";
    homepage = "https://pythonnet.github.io";
    changelog = "https://github.com/pythonnet/pythonnet/releases/tag/v${version}";
    license = licenses.mit;
    # <https://github.com/pythonnet/pythonnet/issues/898>
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [
      jraygauthier
      mdarocha
    ];
  };
}
