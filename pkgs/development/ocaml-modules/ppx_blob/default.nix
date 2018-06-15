{ stdenv, buildOcaml, fetchurl, ppx_tools }:

buildOcaml rec {
  name = "ppx_blob";
  version = "0.2";

  src = fetchurl {
    url = "https://github.com/johnwhitington/ppx_blob/archive/v${version}.tar.gz";
    sha256 = "0kvqfm47f4xbgz0cl7ayz29myyb24xskm35svqrgakjq12nkpsss";
  };

  buildInputs = [ ppx_tools ];

  meta = with stdenv.lib; {
    homepage = https://github.com/johnwhitington/ppx_blob;
    description = "OCaml ppx to include binary data from a file as a string";
    license = licenses.unlicense;
  };
}
