{ stdenv, fetchurl, file }:

stdenv.mkDerivation rec {
  pname = "openpa";
  version = "1.0.4";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://trac.mpich.org/projects/${pname}/raw-attachment/wiki/Downloads/${name}.tar.gz";
    sha256 = "0flyi596hm6fv7xyw2iykx3s65p748s62bf15624xcnwpfrh8ncy";
  };

  prePatch = ''substituteInPlace configure --replace /usr/bin/file ${file}/bin/file'';

  doCheck = true;

  meta = {
    description = "Atomic primitives for high performance, concurrent software";
    homepage = https://trac.mpich.org/projects/openpa;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ leenaars ];
    platforms = with stdenv.lib.platforms; linux;
    longDescription = ''
      OPA (or sometimes OpenPA or Open Portable Atomics) is an
      open source library intended to provide a consistent C API for performing
      atomic operations on a variety of platforms. The main goal of the project is to
      enable the portable usage of atomic operations in concurrent software.
      Developers of client software can worry about implementing and improving their
      concurrent algorithms instead of fiddling with inline assembly syntax and
      learning new assembly dialects in order improve or maintain application
      portability.
    '';
   };
}
