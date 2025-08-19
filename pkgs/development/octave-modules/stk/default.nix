{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "stk";
  version = "2.8.1";

  src = fetchurl {
    url = "https://github.com/stk-kriging/stk/releases/download/${version}/${pname}-${version}-octpkg.tar.gz";
    sha256 = "sha256-wTjM9LUcC8BEj3TNxAz877LqJvuoxWUse9PIZoWGnIU=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/stk/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "STK is a (not so) Small Toolbox for Kriging";
    longDescription = ''
      The STK is a (not so) Small Toolbox for Kriging. Its primary focus is on
      the interpolation/regression technique known as kriging, which is very
      closely related to Splines and Radial Basis Functions, and can be
      interpreted as a non-parametric Bayesian method using a Gaussian Process
      (GP) prior. The STK also provides tools for the sequential and non-sequential
      design of experiments. Even though it is, currently, mostly geared towards
      the Design and Analysis of Computer Experiments (DACE), the STK can be
      useful for other applications areas (such as Geostatistics, Machine
      Learning, Non-parametric Regression, etc.).
    '';
  };
}
