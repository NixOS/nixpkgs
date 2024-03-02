{ lib, buildPythonPackage, fetchFromGitLab, nose, pillow
, isPy3k, isPyPy
}:
buildPythonPackage rec {
  pname = "pypillowfight";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "libpillowfight";
    rev = version;
    sha256 = "096242v425mlqqj5g1giy59p7grxp05g78w6bk37vzph98jrgv3w";
  };

  prePatch = ''
    echo '#define INTERNAL_PILLOWFIGHT_VERSION "${version}"' > src/pillowfight/_version.h
  '';

  # Disable tests because they're designed to only work on Debian:
  # https://github.com/jflesch/libpillowfight/issues/2#issuecomment-268259174
  doCheck = false;

  # Python 2.x is not supported, see:
  # https://github.com/jflesch/libpillowfight/issues/1
  disabled = !isPy3k && !isPyPy;

  # This is needed by setup.py regardless of whether tests are enabled.
  buildInputs = [ nose ];
  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "Library containing various image processing algorithms";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
  };
}
