{ lib, fetchzip }:

let
  pname = "cppreference-doc";
  version = "2022.07.30";
  ver = builtins.replaceStrings ["."] [""] version;

in fetchzip {
  name = pname + "-" + version;

  url = "https://github.com/PeterFeicht/${pname}/releases/download/v${ver}/html-book-${ver}.tar.xz";
  sha256 = "sha256-gsYNpdxbWnmwcC9IJV1g+e0/s4Hoo5ig1MGoYPIHspw=";

  stripRoot = false;

  postFetch = ''
    rm $out/cppreference-doxygen-local.tag.xml $out/cppreference-doxygen-web.tag.xml
    mkdir -p $out/share/cppreference/doc
    mv $out/reference $out/share/cppreference/doc/html
  '';

  passthru = { inherit pname version; };

  meta = with lib; {
    description = "C++ standard library reference";
    homepage = "https://en.cppreference.com";
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.all;
  };
}
