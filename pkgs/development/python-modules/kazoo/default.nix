{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "kazoo";
  version = "2.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kFeWrk9MEr1OSukubl0BhDnmtWyM+7JIJTYuebIw2rE=";
  };

  # tests take a long time to run and leave threads hanging
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://kazoo.readthedocs.org";
    description = "Higher Level Zookeeper Client";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://kazoo.readthedocs.org";
    description = "Higher Level Zookeeper Client";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
