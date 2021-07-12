{ buildOctavePackage
, lib
, fetchurl
# Octave's Python (Python 3)
, python
# Needed only to get the correct version of sympy needed
, python2Packages
}:

let
  # Need to use sympy 1.5.1 for https://github.com/cbm755/octsympy/issues/1023
  # It has been addressed, but not merged yet.
  # In the meantime, we create a Python environment with Python 3, its mpmath
  # version and sympy 1.5 from python2Packages.
  pythonEnv = (let
      overridenPython = let
        packageOverrides = self: super: {
          sympy = super.sympy.overridePythonAttrs (old: rec {
            version = python2Packages.sympy.version;
            src = python2Packages.sympy.src;
          });
        };
      in python.override {inherit packageOverrides; self = overridenPython; };
    in overridenPython.withPackages (ps: [
      ps.sympy
      ps.mpmath
    ]));

in buildOctavePackage rec {
  pname = "symbolic";
  version = "2.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1jr3kg9q6r4r4h3hiwq9fli6wsns73rqfzkrg25plha9195c97h8";
  };

  propagatedBuildInputs = [ pythonEnv ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/symbolic/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Adds symbolic calculation features to GNU Octave";
  };
}
