{ stdenv, buildPythonPackage, fetchPypi,
  click
}:

buildPythonPackage rec {
  pname = "click-didyoumean";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1svaza5lpvdbmyrx5xi0riqzq4hb9wnlpqrg6r8zy14pbi42j8hi";
  };

  propagatedBuildInputs = [ click ];

  meta = with stdenv.lib; {
    description = "Enable git-like did-you-mean feature in click";
    homepage = "https://github.com/click-contrib/click-didyoumean";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
