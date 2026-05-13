{
  fetchpatch,
  fetchzip,
  lib,
  stdenv,

  autoreconfHook,
  cddlib,
  gmpxx,

  programPrefix ? "topcom-",
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "topcom";
  version = "1.1.2";

  versionUrl = builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version;

  src = fetchzip {
    url = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-${finalAttrs.versionUrl}.tgz";
    hash = "sha256-r6dA2rQzxMu0Xxq5yl9rBZ5MJTRnmWVLav/F/QpkZ1A=";
  };

  buildInputs = [
    cddlib
    gmpxx
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  __structuredAttrs = true;

  strictDeps = true;

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/topcom/-/raw/67c9a20c8e1597898f3950b486b4287641823363/system-libs.patch";
      hash = "sha256-F+1ZtluGL3i+LKWp0poQnx2ZlV5TSp6WSK5yl2FmOP4";
    })
  ];

  postPatch = ''
    substituteInPlace lib-src/Makefile.am lib-src-reg/Makefile.am src/Makefile.am src-reg/Makefile.am \
      --replace-fail '$(includedir)/cddlib' '${lib.getDev cddlib}/include/cddlib'
  '';

  configureFlags = [
    "--program-prefix=${programPrefix}"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    for prog in $(find "$out/bin" -type f); do
      echo "Checking $prog"
      grep -q '^usage: ' <(echo "" | "$prog" 2>&1) && continue
      "$prog" --help &>/dev/null && continue
      echo "$prog doesn't seem to be working" >&2
      exit 1
    done
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  meta = {
    description = "Package for computing Triangulations Of Point Configurations and Oriented Matroid";
    longDescription = ''
      TOPCOM is a package for computing Triangulations Of Point Configurations
      and Oriented Matroids. It was very much inspired by the maple program
      PUNTOS, which was written by Jesus de Loera. TOPCOM is entirely written
      in C++, so there is a significant speed up compared to PUNTOS.
    '';
    homepage = "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
