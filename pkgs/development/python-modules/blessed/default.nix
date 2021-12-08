{ lib, buildPythonPackage, fetchFromGitHub, six
, wcwidth, pytest, mock, glibcLocales
}:

buildPythonPackage rec {
  pname = "blessed";
  version = "1.19.0";

  src = fetchFromGitHub {
     owner = "jquast";
     repo = "blessed";
     rev = "1.19.0";
     sha256 = "15yg7qjg83xdfdh62zplsi0spnniqpxs6h5p2k5v35w3h43sh50r";
  };

  checkInputs = [ pytest mock glibcLocales ];

  # Default tox.ini parameters not needed
  checkPhase = ''
    rm tox.ini
    pytest
  '';

  propagatedBuildInputs = [ wcwidth six ];

  meta = with lib; {
    homepage = "https://github.com/jquast/blessed";
    description = "A thin, practical wrapper around terminal capabilities in Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.mit;
  };
}
