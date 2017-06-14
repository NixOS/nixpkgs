{ stdenv, buildPythonPackage, fetchurl,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://pypi/d/daphne/${name}.tar.gz";
    sha256 = "084216isw7rwy693i62rbd8kvpqx418jvf1q72cplv833wz3in7l";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
