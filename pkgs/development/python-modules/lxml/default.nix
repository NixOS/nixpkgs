{ stdenv, buildPythonPackage, fetchFromGitHub
, cython
, libxml2
, libxslt
, zlib
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1i3bhg8xb502afq4ar3kgvvi1hy83l4af2gznfwqvb5b221fr7ak";
  };

  # setuptoolsBuildPhase needs dependencies to be passed through nativeBuildInputs
  nativeBuildInputs = [ libxml2.dev libxslt.dev cython ];
  buildInputs = [ libxml2 libxslt zlib ];

  # tests are meant to be ran "in-place" in the same directory as src
  doCheck = false;

  pythonImportsCheck = [ "lxml" "lxml.etree" ];

  meta = with stdenv.lib; {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = https://lxml.de;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer sjourdois ];
  };
}
