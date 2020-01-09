{ lib
, buildPythonPackage
, fetchFromGitHub
, certifi
, hstspreload
, chardet
, h11
, h2
, idna
, rfc3986
, sniffio
, isPy27
, pytest
, pytestcov
, trustme
, uvicorn
, trio
, brotli
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.9.5";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "140z2j7b5hlcxvfb433hqv5b8irqa88hpq33lzr9m992djbhj2hb";
  };

  propagatedBuildInputs = [
    certifi
    hstspreload
    chardet
    h11
    h2
    idna
    rfc3986
    sniffio
  ];

  checkInputs = [
    pytest
    pytestcov
    trustme
    uvicorn
    trio
    brotli
  ];

  postPatch = ''
    substituteInPlace setup.py \
          --replace "h11==0.8.*" "h11"
  '';

  checkPhase = ''
    PYTHONPATH=.:$PYTHONPATH pytest
  '';

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = https://github.com/encode/httpx;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
