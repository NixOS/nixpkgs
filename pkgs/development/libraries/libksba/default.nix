{ stdenv, fetchurl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libksba-1.0.7";

  src = fetchurl {
    url = "mirror://gnupg/libksba/${name}.tar.bz2";
    sha256 = "1biabl4ijaf0jyl4zf3qrhcs0iaq9pypjibp8wgnim3n3kg0bdda";
  };

  propagatedBuildInputs = [libgpgerror];

  meta = {
    homepage = http://www.gnupg.org;
    description = "Libksba is a CMS and X.509 access library under development";
  };
}
