{ lib
, buildPythonApplication
, fetchFromGitHub
, click
, semantic-version
, requests
, colorama
, pyserial
, wheel
, scons
, setuptools
, tinyprog
, flit-core
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "apio";
  version = "0.9.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "apio";
    rev = "v${version}";
    hash = "sha256-VU4tOszGkw20DWW2SerFsnjFiSkrSwqBcwosGnHJfU8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'scons==4.2.0' 'scons' \
      --replace-fail '==' '>='

    substituteInPlace apio/managers/scons.py --replace-fail \
      'return "tinyprog --libusb --program"' \
      'return "${tinyprog}/bin/tinyprog --libusb --program"'
    substituteInPlace apio/util.py --replace-fail \
      '_command = apio_bin_dir / "tinyprog"' \
      '_command = "${tinyprog}/bin/tinyprog"'

    # semantic-version seems to not support version numbers like the one of tinyprog in Nixpkgs (1.0.24.dev114+gxxxxxxx).
    # See https://github.com/rbarrois/python-semanticversion/issues/47.
    # This leads to an error like "Error: Invalid version string: '1.0.24.dev114+g97f6353'"
    # when executing "apio upload" for a TinyFPGA.
    # Replace the dot with a dash to work around this problem.
    substituteInPlace apio/managers/scons.py --replace-fail \
        'version = semantic_version.Version(pkg_version)' \
        'version = semantic_version.Version(pkg_version.replace(".dev", "-dev"))'
  '';

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
    semantic-version
    requests
    colorama
    pyserial
    wheel
    scons
    setuptools # needs pkg_resources at runtime (technically not needed when tinyprog is also in this list because of the propagatedBuildInputs of tinyprog)

    tinyprog # needed for upload to TinyFPGA
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # This test fails and is also not executed in upstream's CI
    "test2"
  ];

  pytestFlagsArray = [ "--offline" ];

  strictDeps = true;

  meta = with lib; {
    description = "Open source ecosystem for open FPGA boards";
    mainProgram = "apio";
    homepage = "https://github.com/FPGAwars/apio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ Luflosi ];
  };
}
