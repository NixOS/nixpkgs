{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytestCheckHook,
  dotnetCorePackages,
  setuptools,
  setuptools-scm,
  wheel,
  buildDotnetModule,
  cffi,
}:

let
  pname = "clr-loader";
  version = "0.2.6";
  src = fetchPypi {
    pname = "clr_loader";
    inherit version;
    hash = "sha256-AZNIrmtqg8ekBtFFN8J3zs96OlOyY+w0LIHe1YRaZ+4=";
  };

  # This buildDotnetModule is used only to get nuget sources, the actual
  # build is done in `buildPythonPackage` below.
  dotnet-build = buildDotnetModule {
    inherit pname version src;
    projectFile = [
      "netfx_loader/ClrLoader.csproj"
      "example/example.csproj"
    ];
    nugetDeps = ./deps.nix;
  };
in
buildPythonPackage {
  inherit pname version src;

  format = "pyproject";

  buildInputs = [
    dotnetCorePackages.sdk_6_0.packages
    dotnet-build.nugetDeps
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
    dotnetCorePackages.sdk_6_0
  ];

  propagatedBuildInputs = [ cffi ];

  nativeCheckInputs = [ pytestCheckHook ];

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
      -p:Deterministic=true

    dotnet restore "example/example.csproj" \
      -p:ContinuousIntegrationBuild=true \
      -p:Deterministic=true
  '';

  passthru.fetch-deps = dotnet-build.fetch-deps;

  meta = with lib; {
    description = "Generic pure Python loader for .NET runtimes";
    homepage = "https://pythonnet.github.io/clr-loader/";
    license = licenses.mit;
    maintainers = with maintainers; [ mdarocha ];
  };
}
