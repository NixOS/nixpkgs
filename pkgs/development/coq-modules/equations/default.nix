{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

(mkCoqDerivation {
  pname = "equations";
  owner = "mattam82";
  repo = "Coq-Equations";
  inherit version;
  defaultVersion = lib.switch coq.coq-version [
    {
      case = "8.20";
      out = "1.3.1+8.20";
    }
    {
      case = "8.19";
      out = "1.3+8.19";
    }
    {
      case = "8.18";
      out = "1.3+8.18";
    }
    {
      case = "8.17";
      out = "1.3+8.17";
    }
    {
      case = "8.16";
      out = "1.3+8.16";
    }
    {
      case = "8.15";
      out = "1.3+8.15";
    }
    {
      case = "8.14";
      out = "1.3+8.14";
    }
    {
      case = "8.13";
      out = "1.3+8.13";
    }
    {
      case = "8.12";
      out = "1.2.4+coq8.12";
    }
    {
      case = "8.11";
      out = "1.2.4+coq8.11";
    }
    {
      case = "8.10";
      out = "1.2.1+coq8.10-2";
    }
    {
      case = "8.9";
      out = "1.2.1+coq8.9";
    }
    {
      case = "8.8";
      out = "1.2+coq8.8";
    }
    {
      case = "8.7";
      out = "1.0+coq8.7";
    }
    {
      case = "8.6";
      out = "1.0+coq8.6";
    }
  ] null;

  release."1.0+coq8.6".version = "1.0";
  release."1.0+coq8.6".rev = "v1.0";
  release."1.0+coq8.6".sha256 = "19ylw9v9g35607w4hm86j7mmkghh07hmkc1ls5bqlz3dizh5q4pj";
  release."1.0+coq8.7".version = "1.0";
  release."1.0+coq8.7".rev = "v1.0-8.7";
  release."1.0+coq8.7".sha256 = "1bavg4zl1xn0jqrdq8iw7xqzdvdf39ligj9saz5m9c507zri952h";
  release."1.2+coq8.8".version = "1.2";
  release."1.2+coq8.8".rev = "v1.2-8.8";
  release."1.2+coq8.8".sha256 = "06452fyzalz7zcjjp73qb7d6xvmqb6skljkivf8pfm55fsc8s7kx";
  release."1.2.1+coq8.9".version = "1.2.1";
  release."1.2.1+coq8.9".rev = "v1.2.1-8.9";
  release."1.2.1+coq8.9".sha256 = "0d8ddj6nc6p0k25cd8fs17cq427zhzbc3v9pk2wd2fnvk70nlfij";
  release."1.2.1+coq8.10-2".version = "1.2.1";
  release."1.2.1+coq8.10-2".rev = "v1.2.1-8.10-2";
  release."1.2.1+coq8.10-2".sha256 = "0j3z4l5nrbyi9zbbyqkc6kassjanwld2188mwmrbqspaypm2ys68";
  release."1.2.3+coq8.11".version = "1.2.3";
  release."1.2.3+coq8.11".rev = "v1.2.3-8.11";
  release."1.2.3+coq8.11".sha256 = "1srxz1rws8jsh7402g2x2vcqgjbbsr64dxxj5d2zs48pmhb20csf";
  release."1.2.3+coq8.12".version = "1.2.3";
  release."1.2.3+coq8.12".rev = "v1.2.3-8.12";
  release."1.2.3+coq8.12".sha256 = "1y0jkvzyz5ssv5vby41p1i8zs7nsdc8g3pzyq73ih9jz8h252643";
  release."1.2.4+coq8.11".rev = "v1.2.4-8.11";
  release."1.2.4+coq8.11".sha256 = "01fihyav8jbjinycgjc16adpa0zy5hcav5mlkf4s9zvqxka21i52";
  release."1.2.4+coq8.12".rev = "v1.2.4-8.12";
  release."1.2.4+coq8.12".sha256 = "1n0w8is464qcq8mk2mv7amaf0khbjz5mpc9phf0rhpjm0lb22cb3";
  release."1.2.4+coq8.13".rev = "v1.2.4-8.13";
  release."1.2.4+coq8.13".sha256 = "0i014lshsdflzw6h0qxra9d2f0q82vffxv2f29awbb9ad0p4rq4q";
  release."1.3+8.13".rev = "v1.3-8.13";
  release."1.3+8.13".sha256 = "1jwjbkkkk4bwf6pz4zzz8fy5bb17aqyf4smkja59rgj9ya6nrdhg";
  release."1.3+8.14".rev = "v1.3-8.14";
  release."1.3+8.14".sha256 = "19bj9nncd1r9g4273h5qx35gs3i4bw5z9bhjni24b413hyj55hkv";
  release."1.3+8.15".rev = "v1.3-8.15";
  release."1.3+8.15".sha256 = "1vfcfpsp9zyj0sw0cwibk76nj6n0r6gwh8m1aa3lbvc0b1kbm32k";
  release."1.3+8.16".rev = "v1.3-8.16";
  release."1.3+8.16".sha256 = "sha256-zyMGeRObtSGWh7n3WCqesBZL5EgLvKwmnTy09rYpxyE=";
  release."1.3+8.17".rev = "v1.3-8.17";
  release."1.3+8.17".sha256 = "sha256-yNotSIxFkhTg3reZIchGQ7cV9WmTJ7p7hPfKGBiByDw=";
  release."1.3+8.18".rev = "v1.3-8.18";
  release."1.3+8.18".sha256 = "sha256-8MZO9vWdr8wlAov0lBTYMnde0RuMyhaiM99zp7Zwfao=";
  release."1.3+8.19".rev = "v1.3-8.19";
  release."1.3+8.19".sha256 = "sha256-roBCWfAHDww2Z2JbV5yMI3+EOfIsv3WvxEcUbBiZBsk=";
  release."1.3.1+8.20".rev = "v1.3.1-8.20";
  release."1.3.1+8.20".sha256 = "sha256-u8LB1KiACM5zVaoL7dSdHYvZgX7pf30VuqtjLLGuTzc=";

  mlPlugin = true;

  meta = with lib; {
    homepage = "https://mattam82.github.io/Coq-Equations/";
    description = "Plugin for Coq to add dependent pattern-matching";
    maintainers = with maintainers; [ jwiegley ];
  };
}).overrideAttrs
  (o: {
    preBuild = "coq_makefile -f _CoqProject -o Makefile${
      lib.optionalString (lib.versionAtLeast o.version "1.2.1" || o.version == "dev") ".coq"
    }";
  })
