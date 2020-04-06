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
, urllib3
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.12.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "1nrp4h1ppb5vll81fzxmks82p0hxcil9f3mja3dgya511kc703h6";
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
    urllib3
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
