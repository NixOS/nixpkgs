{ stdenv, fetchurl, autoreconfHook, texinfo, dejagnu }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libffi-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "https://github.com/atgreen/libffi/archive/v${version}.tar.gz";
    sha256 = "08xyzr86i782ilcyk58qab28s0b43y0a7jcal6hywar6dzp8vl4n";
  };

  buildInputs = [ autoreconfHook texinfo ] ++ optional doCheck dejagnu;

  configureFlags = [
    "--with-gcc-arch=generic"
  ] ++ optional (stdenv.needsPax) "--enable-pax_emutramp";

  #doCheck = stdenv.isLinux; # until we solve dejagnu problems on darwin and expect on BSD
  doCheck = false; # currently failing

  dontStrip = stdenv ? cross;

  postInstall = ''
    (cd "$out" && ln -s lib/libffi*/include .)
  '';

  meta = {
    description = "A foreign function call interface library";
    longDescription = ''
      The libffi library provides a portable, high level programming
      interface to various calling conventions.  This allows a
      programmer to call any function specified by a call interface
      description at run-time.

      FFI stands for Foreign Function Interface.  A foreign function
      interface is the popular name for the interface that allows code
      written in one language to call code written in another
      language.  The libffi library really only provides the lowest,
      machine dependent layer of a fully featured foreign function
      interface.  A layer must exist above libffi that handles type
      conversions for values passed between the two languages.
    '';
    homepage = https://sourceware.org/libffi/;
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
