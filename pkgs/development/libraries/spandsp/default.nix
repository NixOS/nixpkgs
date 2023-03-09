{ lib, stdenv, fetchurl, audiofile, libtiff, buildPackages
, fetchpatch
, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.0.6";
  pname = "spandsp";

  patches = [
    # submitted upstream: https://github.com/freeswitch/spandsp/pull/47
    (fetchpatch {
      url = "https://github.com/freeswitch/spandsp/commit/1f810894804d3fa61ab3fc2f3feb0599145a3436.patch";
      hash = "sha256-Cf8aaoriAvchh5cMb75yP2gsZbZaOLha/j5mq3xlkVA=";
    })
  ];

  src=fetchurl {
    url = "https://www.soft-switch.org/downloads/spandsp/spandsp-${version}.tar.gz";
    sha256 = "0rclrkyspzk575v8fslzjpgp4y2s4x7xk3r55ycvpi4agv33l1fc";
  };

  outputs = [ "out" "dev" ];
  enableParallelBuilding = true;
  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CC_FOR_BUILD=${buildPackages.stdenv.cc}/bin/cc"
  ];

  configureFlags = [
    # This flag is required to prevent linking error in the cross-compilation case.
    # I think it's fair to assume that realloc(NULL, size) will return a valid memory
    # block for most libc implementation, so let's just assume that and hope for the best.
    "ac_cv_func_malloc_0_nonnull=yes"
  ];

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  propagatedBuildInputs = [audiofile libtiff];
  meta = {
    description = "A portable and modular SIP User-Agent with audio and video support";
    homepage = "http://www.creytiv.com/baresip.html";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.gpl2;
    downloadPage = "http://www.soft-switch.org/downloads/spandsp/";
  };
}
