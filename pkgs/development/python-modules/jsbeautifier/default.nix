{ stdenv, fetchurl, python, wrapPython, pytest }:

stdenv.mkDerivation rec {
  name = "jsbeautifier-1.6.4";
  src = fetchurl {
    url = "https://pypi.python.org/packages/e4/76/dcc8f0d76253763fb6d7035be31cb7be5f185d2877faa96759be40ef5e55/${name}.tar.gz";
    sha256 = "074n8f4ncz5pf0jkkf6i6by30qnaj5208sszaf9p86kgdigcdaf8";
  };

  buildInputs = [ python wrapPython pytest ];

  installPhase = ''
      dst=$out/${python.sitePackages}
      mkdir -p $dst
      export PYTHONPATH="$dst:$PYTHONPATH"
      ${python.interpreter} setup.py install --prefix=$out
      wrapPythonPrograms
  '';

  meta = {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = stdenv.lib.licenses.mit;
        maintainers = with stdenv.lib.maintainers; [ iElectric thoughtpolice cwoac ];
  };
}
