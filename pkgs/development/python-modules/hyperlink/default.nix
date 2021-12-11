{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, idna
, typing ? null
}:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "21.0.0";

  src = fetchFromGitHub {
     owner = "python-hyper";
     repo = "hyperlink";
     rev = "v21.0.0";
     sha256 = "0jrsbgzfaikzv0zsymmzsnsisqd4mkdbw9hvqfxvlj7z9b26rrx5";
  };

  propagatedBuildInputs = [ idna ]
    ++ lib.optionals isPy27 [ typing ];

  meta = with lib; {
    description = "A featureful, correct URL for Python";
    homepage = "https://github.com/python-hyper/hyperlink";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
