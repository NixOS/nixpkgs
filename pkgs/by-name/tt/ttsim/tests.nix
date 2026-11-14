{
  runCommandCC,
  ttsim,
}:

# Start each simulated chip and check the PCI ID it reports: vendor 0x1e52 (Tenstorrent), device
# 0x401e (Wormhole) or 0xb140 (Blackhole), as set in upstream src/pcie.cpp
runCommandCC "ttsim-pci-id" { meta.timeout = 300; } ''
  $CC -std=c11 -Wall -Werror -o test ${./test-pci-id.c} -ldl
  ./test ${ttsim}/lib/libttsim_wh.so 401e1e52
  ./test ${ttsim}/lib/libttsim_bh.so b1401e52
  touch $out
''
