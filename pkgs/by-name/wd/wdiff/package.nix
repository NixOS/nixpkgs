{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  which,
}:

stdenv.mkDerivation rec {
  pname = "wdiff";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://gnu/wdiff/${pname}-${version}.tar.gz";
    sha256 = "0sxgg0ms5lhi4aqqvz1rj4s77yi9wymfm3l3gbjfd1qchy66kzrl";
  };

  # for makeinfo
  nativeBuildInputs = [ texinfo ];

  buildInputs = [ texinfo ];

  nativeCheckInputs = [ which ];

  strictDeps = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/wdiff/";
    description = "Comparing files on a word by word basis";
    mainProgram = "wdiff";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
