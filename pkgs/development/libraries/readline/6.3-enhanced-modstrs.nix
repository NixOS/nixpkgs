{ pkgs, fetchurl, stdenv, ncurses }:

let
  patch = commit: sha256:
    fetchurl {
      url = "https://github.com/calid/readline/commit/${commit}.patch";
      inherit sha256;
    };

  patchList = [
    (patch "de57f1570204836db26eec33d826cefce092584c" "0gsczgcj65m8knwb6bs0hg59jvcfci6sry9hsg2nw5p7d67pkmni")
    (patch "cb40fcacb3bc2e1f777e7615420682bec85b2abe" "1126w9jhkncmgcc8rqv9l1q6hcrd6f9shg1vgv3y4zfy5blp722w")
    (patch "cf72f4af7ebf53344a133fd9f95948b21d55f089" "10sbmfkd8dm6w1ymg1h8f9a0xpaflcfq8gvk1wk86195asm9r0ba")
    (patch "c5eab3793a0f29a2ae6a43dea2dfc3bf74d784ee" "14y9mbckf38vvkmcllbszbw00slvv3yzj4ynsqabz3vzkyips4ig")
    (patch "c3b51e8ac52156b8fa7351ec920dac18b0e9a61b" "0k51igbj6ww8iwinpl2cznwc9pvk4836fx80yhl0sxxzapinmk17")
    (patch "3b7e102bb4b829ca4e8cac32d7aac4f2ddef06c9" "0d71sy64wh9w6ga3g65ha1ksx1fq6rgk2nlqcrzsrlq8w66pw4z4")
    (patch "eca93644bad2830ec338c7e41594756a590007f2" "1rjp2444663h3afih5dppkwgs6l2vf7c8r4cs14phgn6zcyx52zg")
    (patch "f91dc79504f49b4e3992a34a3372963675a25335" "0f37diz9k5vd84ab5rywmx06lj74cgscryva8az7pcr0gi6jpj2h")
    (patch "a9f9a9a91d33d998d6acc88603b059a17a59825a" "0cvpdpj6r6p7rlzcmgkbr73x005jm7b5j3dygspxwsnirmlmsj84")
    (patch "a2ef58fe95dd0e5212d810183b1a8c5e00e015f4" "12fjid3l1fvfmd7fd81aphxpz59r16aa1fs2adxim1dx3ch5b5j2")
    (patch "295648343dfc9096ef91c820107eed47cd7128a1" "19wwhl7w6m251cpr19az0siamxny6hshrpdqpms2x4k6afaksacc")
    (patch "14640c16b661d3b13d2eb55743243db5cf5274f6" "0h66mq46zfk74j5fm8vwg97ybzl0yfc0zzshnkcjavn1xpfh9pad")
    (patch "5020f845c7c06d6b312501f62325fb89a39f16e8" "0404517w0pml1bfak2qi8dyn4b66jc2vf5i0is7pwjsgwpwrp4qz")
    (patch "108f1d6586e4c2fabf231efbd9aa9cab0f657703" "1awi1d4qkjgfagny239jhz16vlazva5xa67d5m15rhjcn2jsvr08")
  ];

in
pkgs.callPackage ./6.3.nix {
  inherit fetchurl stdenv ncurses;
  additionalPatches = patchList;
}

