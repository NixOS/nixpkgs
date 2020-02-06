{ stdenv
, buildPythonPackage
, fetchFromGitHub
, requests
, python
}:

buildPythonPackage rec {
  pname = "requests-http-signature";
  version = "0.1.0";

  # .pem files for tests aren't present on PyPI
  src = fetchFromGitHub {
    owner = "pyauth";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y96wsbci296m1rcxx0ybx8r44rdvyb59p1jl27p7rgz7isr3kx1";
  };

  propagatedBuildInputs = [ requests ];

  checkPhase = ''
    ${python.interpreter} test/test.py
  '';

  meta = with stdenv.lib; {
    description = "A Requests auth module for HTTP Signature";
    homepage = "https://github.com/kislyuk/requests-http-signature";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmai ];
  };
}
