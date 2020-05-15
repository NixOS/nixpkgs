{buildPythonPackage, fetchurl, rpmextract, python, wirelesstools, gettext}:

buildPythonPackage {
  pname = "rhpl";
  version = "0.218";
  format = "other";

  src = fetchurl {
    url = "http://ftp-stud.hs-esslingen.de/pub/Mirrors/archive.fedoraproject.org/fedora/linux/releases/10/Everything/source/SRPMS//rhpl-0.218-1.src.rpm";
    sha256 = "0c3sc74cjzz5dmpr2gi5naxcc5p2qmzagz7k561xj07njn0ddg16";
  };

  inherit python;

  builder = ./builder.sh;

  nativeBuildInputs = [ rpmextract  gettext ];
  buildInputs = [ wirelesstools ];
}
