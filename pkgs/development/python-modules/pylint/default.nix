{ stdenv, buildPythonPackage, fetchPypi, python, astroid, isort,
  pytest, pytestrunner,  mccabe, configparser, backports_functools_lru_cache }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pylint";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cd70527ef3b099543eeabeb5c80ff325d86b477aa2b3d49e264e12d12153bc8";
  };

  buildInputs = [ pytest pytestrunner mccabe configparser backports_functools_lru_cache ];

  propagatedBuildInputs = [ astroid configparser isort mccabe ];

  postPatch = ''
    # Remove broken darwin tests
    sed -i -e '/test_parallel_execution/,+2d' pylint/test/test_self.py
    sed -i -e '/test_py3k_jobs_option/,+4d' pylint/test/test_self.py
    rm -vf pylint/test/test_functional.py
  '';

  checkPhase = ''
    cd pylint/test
    ${python.interpreter} -m unittest discover -p "*test*"
  '';

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    cp "elisp/"*.el $out/share/emacs/site-lisp/
  '';

  meta = with stdenv.lib; {
    homepage = https://www.logilab.org/project/pylint;
    description = "A bug and style checker for Python";
    platforms = platforms.all;
    license = licenses.gpl1Plus;
    maintainers = with maintainers; [ nand0p ];
  };
}
