{ lib
, fetchPypi
, fetchpatch
, buildPythonPackage
, openssl
, pylsqpack
, certifi
, pytestCheckHook
, pyopenssl
}:

buildPythonPackage rec {
  pname = "aioquic";
  version = "0.9.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7ENqqs6Ze4RrAeUgDtv34+VrkYJqFE77l0j9jd0zK74=";
  };

  patches = [
    # This patch is here because it's required by the next patch.
    (fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/3930580b50831a034d21ee4689362188b21a4d6a.patch";
      hash = "sha256-XjhyajDawN/G1nPtkMbNe66iJCo76UpdA7PqwtxO5ag=";
    })
    # https://github.com/aiortc/aioquic/pull/349, fixes test failure due pyopenssl==22
    (assert lib.versions.major pyopenssl.version == "22"; fetchpatch {
      url = "https://github.com/aiortc/aioquic/commit/c3b72be85868d67ee32d49ab9bd98a4357cbcde9.patch";
      hash = "sha256-AjW+U9DpNXgA5yqKkWnx0OYpY2sZR9KIdQ3pSzxU+uY=";
    })
  ];

  propagatedBuildInputs = [
    certifi
    pylsqpack
    pyopenssl
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioquic" ];

  meta = with lib; {
    description = "Implementation of QUIC and HTTP/3";
    homepage = "https://github.com/aiortc/aioquic";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
