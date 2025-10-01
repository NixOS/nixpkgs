{
  lib,
  version,
  targetPrefix,
}:

let
  inherit (lib)
    licenses
    maintainers
    platforms
    teams
    versionOlder
    ;
in
{
  homepage = "https://gcc.gnu.org/";
  license = licenses.gpl3Plus; # runtime support libraries are typically LGPLv3+
  description = "GNU Compiler Collection, version ${version}";
  longDescription = ''
    The GNU Compiler Collection includes compiler front ends for C, C++,
    Objective-C, Fortran, OpenMP for C/C++/Fortran, and Ada, as well as
    libraries for these languages (libstdc++, libgomp,...).

    GCC development is a part of the GNU Project, aiming to improve the
    compiler used in the GNU system including the GNU/Linux variant.
  '';

  platforms = platforms.unix;
  teams = [ teams.gcc ];
  mainProgram = "${targetPrefix}gcc";

  identifiers.cpeParts.vendor = "gnu";
}
