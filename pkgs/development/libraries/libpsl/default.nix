{ stdenv, fetchFromGitHub, autoreconfHook, icu, libxslt, pkgconfig }:

let version = "0.7.1"; in
stdenv.mkDerivation rec {
  name = "libpsl-${version}";

  src = fetchFromGitHub {
    sha256 = "0hbsidbmwgpg0h48wh2pzsq59j8az7naz3s5q3yqn99yyjji2vgw";
    rev = name;
    repo = "libpsl";
    owner = "rockdaboot";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = http://rockdaboot.github.io/libpsl/;
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ icu libxslt ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  configureFlags = "--disable-static --enable-man";

  enableParallelBuilding = true;

  doCheck = true;
}
