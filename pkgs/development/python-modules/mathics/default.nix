{ stdenv
, buildPythonPackage
, fetchFromGitHub
, django
, python
, cython
, sympy
, ply
, mpmath
, dateutil
, colorama
, six
, pexpect
}:

if (stdenv.lib.versionOlder django.version "1.8") ||
   (stdenv.lib.versionAtLeast django.version "1.9")
   then throw "mathics only supports django-1.8.x"
   else buildPythonPackage rec {
  pname = "mathics";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "mathics";
    repo = "Mathics";
    rev = "v${version}";
    sha256 = "0xzz7j8xskj5y6as178mjmm0i2xbhd4q4mwmdnvghpd2aqq3qx1c";
  };

  buildInputs = [ pexpect ];

  prePatch = ''
    substituteInPlace setup.py --replace "sympy==0.7.6" "sympy"
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/bin $out
    patchPythonScript $out/${python.sitePackages}/mathics/manage.py
  '';

  propagatedBuildInputs = [ cython sympy django ply mpmath dateutil colorama six ];

  meta = with stdenv.lib; {
    description = "A general-purpose computer algebra system";
    homepage = http://www.mathics.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.benley ];
  };

}
