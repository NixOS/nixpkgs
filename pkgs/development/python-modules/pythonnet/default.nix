{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,
  pytestCheckHook,
  pycparser,
  psutil,
  dotnet-sdk_10,
  buildDotnetModule,
  clr-loader,
  packaging,
  pyproject-parser,
  setuptools,
}:

let
  pname = "pythonnet";
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "pythonnet";
    repo = "pythonnet";
    tag = "v${version}";
    hash = "sha256-hE0dDcbImBPS6/aZlRHkziKBE+REtso3g14Tqs6vucc=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    projectFile = "src/runtime/Python.Runtime.csproj";
    testProjectFile = "src/testing/Python.Test.csproj";
    nugetDeps = ./deps.json;
    dotnet-sdk = dotnet-sdk_10;
  };
in
buildPythonPackage {
  inherit pname version src;

  disabled = pythonAtLeast "3.14";

  pyproject = true;

  # Upstream's commented-out CoreCLR hint targets net6.0, which the .NET 10 SDK can't run
  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail '        # fw = "net6.0"' '        fw = "net10.0"'
  '';

  buildInputs = dotnet-build.nugetDeps;

  build-system = [
    packaging
    pyproject-parser
    setuptools
  ];

  nativeBuildInputs = [ dotnet-sdk_10 ];

  dependencies = [
    pycparser
    clr-loader
  ];

  pytestFlags = [
    # Run tests using .NET Core, Mono is unsupported for now due to find_library problem in clr-loader
    "--runtime=coreclr"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil # needed for memory leak tests
  ];

  passthru = {
    # Rerun this when updating to refresh Nuget dependencies
    inherit (dotnet-build) fetch-deps;
    # update-python-libraries only bumps version and hash, leaving deps.json stale
    skipBulkUpdate = true;
  };

  meta = {
    description = ".NET integration for Python";
    homepage = "https://pythonnet.github.io";
    changelog = "https://github.com/pythonnet/pythonnet/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    # <https://github.com/pythonnet/pythonnet/issues/898>
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      jraygauthier
      mdarocha
    ];
  };
}
