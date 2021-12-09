{ lib
, fetchFromGitHub
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "dpkt";
  version = "1.9.7.2";

  src = fetchFromGitHub {
     owner = "kbandla";
     repo = "dpkt";
     rev = "v1.9.7.2";
     sha256 = "115m0n7lda54yqy0ax8aqlqwf8c07pdxcxf3fz8437gpwnrbyh5a";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "dpkt" ];

  meta = with lib; {
    description = "Fast, simple packet creation / parsing, with definitions for the basic TCP/IP protocols";
    homepage = "https://github.com/kbandla/dpkt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.all;
  };
}
