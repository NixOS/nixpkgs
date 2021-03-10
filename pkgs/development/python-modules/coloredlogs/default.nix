{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, humanfriendly
, verboselogs
, capturer
, pytest
, mock
, util-linux
}:

buildPythonPackage rec {
  pname = "coloredlogs";
  version = "15.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-coloredlogs";
    rev = version;
    sha256 = "sha256-C1Eo+XrrL3bwhT49KyOE6xjbAHJxn9Qy4s1RR5ERVtA=";
  };

  # capturer is broken on darwin / py38, so we skip the test until a fix for
  # https://github.com/xolox/python-capturer/issues/10 is released.
  doCheck = !stdenv.isDarwin;
  checkPhase = ''
    PATH=$PATH:$out/bin pytest . -k "not test_plain_text_output_format \
                                     and not test_auto_install"
  '';
  checkInputs = [ pytest mock util-linux verboselogs capturer ];

  pythonImportsCheck = [ "coloredlogs" ];

  propagatedBuildInputs = [ humanfriendly ];

  meta = with lib; {
    description = "Colored stream handler for Python's logging module";
    homepage = "https://github.com/xolox/python-coloredlogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
