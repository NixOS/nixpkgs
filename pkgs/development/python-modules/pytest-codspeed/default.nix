{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-xdist,
  pytest,
  pytestCheckHook,
  rich,
  semver,
  setuptools,
}:

let
  # Upstream gates the build with platform.system()/machine() on BUILD;
  # the generated extension also needs a supported HOST architecture.
  nativeExtensionSupported =
    lib.all
      (
        platform:
        builtins.elem platform.system [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ]
      )
      [
        stdenv.buildPlatform
        stdenv.hostPlatform
      ];
  instrument-hooks = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "instrument-hooks";
    # Match the instrument-hooks submodule in pytest-codspeed's release tag.
    rev = "b9ddb5bc654b2e6fa13eb18efcd3a45e7ecda0bb";
    hash = "sha256-BNlixr0E/Im1molVNX2ykHWukLQxnNcva+pbhyhZhQg=";
  };
in

buildPythonPackage rec {
  pname = "pytest-codspeed";
  version = "5.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CodSpeedHQ";
    repo = "pytest-codspeed";
    tag = "v${version}";
    hash = "sha256-qlv7iCT1q/U8fWbXGYQyw2mcR7GS9w41FlRQvRxnHh8=";
  };

  postPatch = ''
    pushd src/pytest_codspeed/instruments/hooks
    rmdir instrument-hooks
    ln -nsf ${instrument-hooks} instrument-hooks
    popd
  '';

  build-system = [
    cffi
    setuptools
  ];

  # The bundled Zig-generated C uses a noreturn attribute placement rejected
  # by C23. Its C17 _Noreturn spelling works with the emitted declarations.
  env = {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  }
  // lib.optionalAttrs nativeExtensionSupported {
    PYTEST_CODSPEED_FORCE_EXTENSION_BUILD = "1";
  };

  buildInputs = [ pytest ];

  dependencies = [
    cffi
    rich
  ];

  optional-dependencies = {
    compat = [
      pytest-benchmark
      pytest-xdist
    ];
  };

  nativeCheckInputs = [
    semver
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_codspeed"
  ]
  ++ lib.optional nativeExtensionSupported (
    # Check the extension itself, not just the fallback-capable Python package.
    "pytest_codspeed.instruments.hooks.dist_instrument_hooks"
  );

  meta = {
    description = "Pytest plugin to create CodSpeed benchmarks";
    homepage = "https://github.com/CodSpeedHQ/pytest-codspeed";
    changelog = "https://github.com/CodSpeedHQ/pytest-codspeed/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
