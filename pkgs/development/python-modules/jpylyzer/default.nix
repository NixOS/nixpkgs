{ stdenv
, fetchFromGitHub
, buildPythonPackage
, six
}:

buildPythonPackage rec {
  pname = "jpylyzer";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = pname;
    rev = version;
    sha256 = "0vhrq15l6jd5fm6vj7mczjzjpl2ph1dk8jp89dw4vlccky8660ll";
  };

  propagatedBuildInputs = [ six ];

  # there don't appear to be any in-tree tests as such, but the builder's automatic
  # runner seems to be upset by the project layout
  doCheck = false;

  meta = with stdenv.lib; {
    description = "JP2 (JPEG 2000 Part 1) image validator and properties extractor";
    homepage = "https://jpylyzer.openpreservation.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ris ];
  };
}
