{ lib
, buildPythonPackage
, fetchFromGitHub
, humanfriendly
, verboselogs
, capturer
, pytest
, mock
, utillinux
}:

buildPythonPackage rec {
  pname = "coloredlogs";
  version = "14.0";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-coloredlogs";
    rev = version;
    sha256 = "0rnmxwrim4razlv4vi3krxk5lc5ksck6h5374j8avqwplika7q2x";
  };

  checkPhase = ''
    PATH=$PATH:$out/bin pytest . -k "not test_plain_text_output_format \
                                     and not test_auto_install"
  '';
  checkInputs = [ pytest mock utillinux ];

  propagatedBuildInputs = [ humanfriendly verboselogs capturer ];

  meta = with lib; {
    description = "Colored stream handler for Python's logging module";
    homepage = "https://github.com/xolox/python-coloredlogs";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
