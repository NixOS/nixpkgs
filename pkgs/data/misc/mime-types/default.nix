{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mime-types-${version}";
  version = "9";

  src = fetchurl {
    url = "https://mirrors.kernel.org/gentoo/distfiles/${name}.tar.bz2";
    sha256 = "0pib8v0f5xwwm3xj2ygdi2dlxxvbq6p95l3fah5f66qj9xrqlqxl";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/etc mime.types
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A database of common mappings of file extensions to MIME types";
    homepage = https://packages.gentoo.org/packages/app-misc/mime-types;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
