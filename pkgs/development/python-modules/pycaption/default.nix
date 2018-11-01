{ lib, fetchpatch
, buildPythonPackage, fetchPypi, isPy3k
, beautifulsoup4, lxml, cssutils, future, enum34, six
}:

buildPythonPackage rec {
  pname = "pycaption";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f2hx9ky65c4niws3x5yx59yi8mqqrw9b2cghd220g4hj9yl800h";
  };

  disabled = !isPy3k;

  prePatch = ''
    substituteInPlace setup.py \
      --replace 'beautifulsoup4>=4.2.1,<4.5.0' \
                'beautifulsoup4>=4.2.1,<=4.6.3'
  '';

  # don't require enum34 on python >= 3.4
  patches = [
    (fetchpatch {
        url = "https://github.com/pbs/pycaption/pull/161.patch";
        sha256 = "0p58awpsqx1qc3x9zfl1gd85h1nk7204lzn4kglsgh1bka0j237j";
    })
  ];

  propagatedBuildInputs = [ beautifulsoup4 lxml cssutils future enum34 six ];

  # Tests not included in pypi (?)
  doCheck = false;

  meta = with lib; {
    description = "Closed caption converter";
    homepage = https://github.com/pbs/pycaption;
    license = with licenses; [ asl20 ];
  };
}
