{ lib, fetchzip, mkFont }:

mkFont rec {
  version = "0.113";
  name = "Amiri-${version}";

  src = fetchzip {
    url = "https://github.com/alif-type/amiri/releases/download/${version}/${name}.zip";
    sha256 = "0cf0brihs1pilbrz0bpyg4xh8xsdhysy3m77ibz28wwyfy7wv09k";
  };

  meta = with lib; {
    description = "A classical Arabic typeface in Naskh style";
    homepage = "https://www.amirifont.org/";
    license = licenses.ofl;
    maintainers = [ maintainers.vbgl ];
    platforms = platforms.all;
  };
}
