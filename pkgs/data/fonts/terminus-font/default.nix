{ stdenv, fetchurl, python3, bdftopcf, mkfontdir, mkfontscale
# Some characters are implemented in two variants. See the font homepage
# for examples. If you want to combine hi2 with dv1 and/or ka2, apply
# hi2 and then hi2-dv1 and/or hi2-ka2, as mentioned in the README file.
, ao2Variant ? false      # `a' like `o'
, br1Variant ? false      # Braille
, dv1Variant ? false      # ru `dv'
, ge2Variant ? false      # ru `g'
, gq2Variant ? false      # quote
, hi2Variant ? false      # higher upper case letters, digits etc.
, hi2-dv1Variant ? false  # hi2 and dv1 combo
, hi2-ka2Variant ? false  # hi2 and ka2 combo
, ij1Variant ? false      # ru `i'
, ka2Variant ? false      # ru `k'
, ll2Variant ? false      # distinct `l' (should pass the il1I test)
, td1Variant ? false      # center tilde
}:

stdenv.mkDerivation rec {
  pname = "terminus-font";
  version = "4.47";
  name = "${pname}-${version}"; # set here for use in URL below

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${name}/${name}.tar.gz";
    sha256 = "15qjcpalcxjiwsjgjg5k88vkwp56cs2nnx4ghya6mqp4i1c206qg";
  };

  nativeBuildInputs = [ python3 bdftopcf mkfontdir mkfontscale ];

  patchPhase = ''
    substituteInPlace Makefile --replace 'fc-cache' '#fc-cache'
    '' + stdenv.lib.optionalString ao2Variant ''patch -p1 -i alt/ao2.diff
    '' + stdenv.lib.optionalString br1Variant ''patch -p1 -i alt/br1.diff
    '' + stdenv.lib.optionalString dv1Variant ''patch -p1 -i alt/dv1.diff
    '' + stdenv.lib.optionalString ge2Variant ''patch -p1 -i alt/ge2.diff
    '' + stdenv.lib.optionalString gq2Variant ''patch -p1 -i alt/gq2.diff
    '' + stdenv.lib.optionalString hi2Variant ''patch -p1 -i alt/hi2.diff
    '' + stdenv.lib.optionalString hi2-dv1Variant ''patch -p1 -i alt/hi2-dv1.diff
    '' + stdenv.lib.optionalString hi2-ka2Variant ''patch -p1 -i alt/hi2-ka2.diff
    '' + stdenv.lib.optionalString ij1Variant ''patch -p1 -i alt/ij1.diff
    '' + stdenv.lib.optionalString ka2Variant ''patch -p1 -i alt/ka2.diff
    '' + stdenv.lib.optionalString ll2Variant ''patch -p1 -i alt/ll2.diff
    '' + stdenv.lib.optionalString td1Variant ''patch -p1 -i alt/td1.diff
    '';

  enableParallelBuilding = true;

  installTargets = [ "install" "fontdir" ];

  meta = with stdenv.lib; {
    description = "A clean fixed width font";
    longDescription = ''
      Terminus Font is designed for long (8 and more hours per day) work
      with computers. Version 4.30 contains 850 characters, covers about
      120 language sets and supports ISO8859-1/2/5/7/9/13/15/16,
      Paratype-PT154/PT254, KOI8-R/U/E/F, Esperanto, many IBM, Windows and
      Macintosh code pages, as well as the IBM VGA, vt100 and xterm
      pseudographic characters.

      The sizes present are 6x12, 8x14, 8x16, 10x20, 11x22, 12x24, 14x28 and
      16x32. The styles are normal and bold (except for 6x12), plus
      EGA/VGA-bold for 8x14 and 8x16.
    '';
    homepage = http://terminus-font.sourceforge.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ astsmtl ];
  };
}
