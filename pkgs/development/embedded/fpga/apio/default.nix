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
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "apio";
  version = "0.8.1";
  format = "flit";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "apio";
    rev = "v${version}";
    sha256 = "sha256-04qAGTzusMT3GsaRxDoXNJK1Mslzxu+ugQclBJx8xzE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'scons==4.2.0' 'scons' \
      --replace '==' '>='

    substituteInPlace apio/managers/scons.py --replace \
      'return "tinyprog --libusb --program"' \
      'return "${tinyprog}/bin/tinyprog --libusb --program"'
    substituteInPlace apio/util.py --replace \
      '_command = join(get_bin_dir(), "tinyprog")' \
      '_command = "${tinyprog}/bin/tinyprog"'

    # semantic-version seems to not support version numbers like the one of tinyprog in Nixpkgs (1.0.24.dev114+gxxxxxxx).
    # See https://github.com/rbarrois/python-semanticversion/issues/47.
    # This leads to an error like "Error: Invalid version string: '1.0.24.dev114+g97f6353'"
    # when executing "apio upload" for a TinyFPGA.
    # Replace the dot with a dash to work around this problem.
    substituteInPlace apio/managers/scons.py --replace \
        'version = semantic_version.Version(pkg_version)' \
        'version = semantic_version.Version(pkg_version.replace(".dev", "-dev"))'
  '';

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

  pytestFlagsArray = [ "--offline" ];

  meta = with lib; {
    description = "Open source ecosystem for open FPGA boards";
    homepage = "https://github.com/FPGAwars/apio";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ Luflosi ];
  };
}
