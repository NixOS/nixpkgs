# Stages 3 to 5: the compiler proper compiled from the pristine source by the
# native compiler of the stage before, as stage 2 is compiled by stage 1.  A
# native compile is about twenty times faster, so one derivation holds all 220
# modules.  Stage 5 stops at .hi and .hc files, which the fixed-point check
# compares with stage 4's.
{
  stage2,
  compiler,
  stage,
  link ? true,
}:

let
  name = "stage${toString stage}";
  hc = stage2.hcChunk {
    part = "";
    from = 1;
    to = 220;
    stage = name;
    ghc = "${compiler}/bin/ghc";
    fixups = false;
    flags = "/dev/null";
    modTimeout = 1800;
  };
in
if link then
  stage2.linked {
    stage = name;
    inherit hc;
    ref = compiler;
  }
else
  hc
