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
  setuptools,
}:

let
  pname = "pythonnet";
  version = "3.0.5";
  src = fetchFromGitHub {
    owner = "pythonnet";
    repo = "pythonnet";
    tag = "v${version}";
    hash = "sha256-3LBrV/cQrXFKMFE1rCalDsPZ3rOY7RczqXoryMoVi14=";
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'

    # .NET SDK 10 uses a newer toolchain that triggers NonCopyableAnalyzer failures
    # in this release; disable analyzers for the Nix build to keep the package building.
    substituteInPlace Directory.Build.props \
      --replace-fail '</PropertyGroup>' $'  <RunAnalyzers>false</RunAnalyzers>\n  </PropertyGroup>'

    # Tests (run with --runtime=coreclr) need a CoreCLR target; net6.0 requires a
    # runtime that isn't shipped with the .NET 10 SDK, so target net10.0 instead.
    substituteInPlace src/testing/Python.Test.csproj \
      --replace-fail 'netstandard2.0;net6.0' 'netstandard2.0;net10.0'

    substituteInPlace tests/conftest.py \
      --replace-fail '        # fw = "net6.0"' '        fw = "net10.0"'
  '';

  buildInputs = dotnet-build.nugetDeps;

  nativeBuildInputs = [
    setuptools
    dotnet-sdk_10
  ];

  propagatedBuildInputs = [
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

  # Rerun this when updating to refresh Nuget dependencies
  passthru.fetch-deps = dotnet-build.fetch-deps;

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
