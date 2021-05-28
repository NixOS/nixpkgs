{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, h11
, sniffio
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.10.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "00gn8nfv814rg6fj7xv97mrra3fvx6fzjcgx9y051ihm6hxljdsi";
  };

  propagatedBuildInputs = [ h11 sniffio ];

  # tests require pythonic access to mitmproxy, which isn't (yet?) packaged as
  # a pythonPackage.
  doCheck = false;
  pythonImportsCheck = [ "httpcore" ];

  meta = with stdenv.lib; {
    description = "A minimal HTTP client";
    homepage = "https://github.com/encode/httpcore";
    license = licenses.bsd3;
    maintainers = [ maintainers.ris ];
  };
}
