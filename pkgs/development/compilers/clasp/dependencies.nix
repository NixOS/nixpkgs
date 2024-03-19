# Gathered from https://github.com/clasp-developers/clasp/raw/2.2.0/repos.sexp
# Generated using https://gist.github.com/philiptaron/8ea1394b049c2ca975e4b03965d9ac00
# and then light editing using Vim

{ fetchFromGitHub }:

[
  {
    directory = "dependencies/ansi-test/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "ansi-test";
      rev = "33ae7c1ddd3e814bbe6f55b9e7a6a92b39404664";
      hash = "sha256-dGF7CScvfPNMRxQXJM4v6Vfc/VjdUXNz0yCjUOsYM3I=";
    };
  }

  {
    directory = "dependencies/cl-bench/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "cl-bench";
      rev = "7d184b4ef2a6272f0e3de88f6c243edb20f7071a";
      hash = "sha256-7ZEIWNEj7gzYFMTqW7nnZgjNE1zoTAMeJHj547gRtPs=";
    };
  }

  {
    directory = "dependencies/cl-who/";
    src = fetchFromGitHub {
      owner = "edicl";
      repo = "cl-who";
      rev = "07dafe9b351c32326ce20b5804e798f10d4f273d";
      hash = "sha256-5T762W3qetAjXtHP77ko6YZR6w5bQ04XM6QZPELQu+U=";
    };
  }

  {
    directory = "dependencies/quicklisp-client/";
    src = fetchFromGitHub {
      owner = "quicklisp";
      repo = "quicklisp-client";
      rev = "8b63e00b3a2b3f96e24c113d7601dd03a128ce94";
      hash = "sha256-1HLVPhl8aBaeG8dRLxBh0j0X/0wqFeNYK1CEfiELToA=";
    };
  }

  {
    directory = "dependencies/shasht/";
    src = fetchFromGitHub {
      owner = "yitzchak";
      repo = "shasht";
      rev = "f38e866990c6b5381a854d63f7ea0227c87c2f6d";
      hash = "sha256-Ki5JNevMvVZoUz3tP6cv7qA4xDLzjd2MXmf4x9ew5bw=";
    };
  }

  {
    directory = "dependencies/trivial-do/";
    src = fetchFromGitHub {
      owner = "yitzchak";
      repo = "trivial-do";
      rev = "a19f93227cb80a6bec8846655ebcc7998020bd7e";
      hash = "sha256-Tjd9VJan6pQpur292xtklvb28MDGGjq2+ub5T6o6FG8=";
    };
  }

  {
    directory = "dependencies/trivial-gray-streams/";
    src = fetchFromGitHub {
      owner = "trivial-gray-streams";
      repo = "trivial-gray-streams";
      rev = "2b3823edbc78a450db4891fd2b566ca0316a7876";
      hash = "sha256-9vN74Gum7ihKSrCygC3hRLczNd15nNCWn5r60jjHN8I=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/Acclimation/";
    src = fetchFromGitHub {
      owner = "robert-strandh";
      repo = "Acclimation";
      rev = "dd15c86b0866fc5d8b474be0da15c58a3c04c45c";
      hash = "sha256-AuoVdv/MU73A8X+GsxyG0K+xgzCKLQfbpu79oTERgmI=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/alexandria/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "alexandria";
      rev = "49e82add16cb9f1ffa72c77cd687271247181ff3";
      hash = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/anaphora/";
    src = fetchFromGitHub {
      owner = "spwhitton";
      repo = "anaphora";
      rev = "bcf0f7485eec39415be1b2ec6ca31cf04a8ab5c5";
      hash = "sha256-CzApbUmdDmD+BWPcFGJN0rdZu991354EdTDPn8FSRbc=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/architecture.builder-protocol/";
    src = fetchFromGitHub {
      owner = "scymtym";
      repo = "architecture.builder-protocol";
      rev = "0c1a9ebf9ab14e699c2b9c85fc20265b8c5364dd";
      hash = "sha256-AdZeI4UCMnmuYpmSaWqIt+egdkNN3kzEn/zOqIBTnww=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/array-utils/";
    src = fetchFromGitHub {
      owner = "Shinmera";
      repo = "array-utils";
      rev = "5acd90fa3d9703cea33e3825334b256d7947632f";
      hash = "sha256-Br3H39F+hqYnTgYtVezuRhwRQJwJlxohu+M033sYPOI=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/babel/";
    src = fetchFromGitHub {
      owner = "cl-babel";
      repo = "babel";
      rev = "f892d0587c7f3a1e6c0899425921b48008c29ee3";
      hash = "sha256-U2E8u3ZWgH9eG4SV/t9CE1dUpcthuQMXgno/W1Ow2RE=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/bordeaux-threads/";
    src = fetchFromGitHub {
      owner = "sionescu";
      repo = "bordeaux-threads";
      rev = "3d25cd01176f7c9215ebc792c78313cb99ff02f9";
      hash = "sha256-KoOaIKQZaZgEbtM6PGVwQn/xg+/slt+uloR4EaMlBeg=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/cffi/";
    src = fetchFromGitHub {
      owner = "cffi";
      repo = "cffi";
      rev = "9c912e7b89eb09dd347d3ebae16e4dc5f53e5717";
      hash = "sha256-umt0HmX7M3SZM2VSrxqxUmNt9heTG/Ulwzphs2NRYTs=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/cl-markup/";
    src = fetchFromGitHub {
      owner = "arielnetworks";
      repo = "cl-markup";
      rev = "e0eb7debf4bdff98d1f49d0f811321a6a637b390";
      hash = "sha256-50LZDaNfXhOZ6KoTmXClo5Bo2D9q1zbdCLSFkwqZhoI=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/cl-ppcre/";
    src = fetchFromGitHub {
      owner = "edicl";
      repo = "cl-ppcre";
      rev = "b4056c5aecd9304e80abced0ef9c89cd66ecfb5e";
      hash = "sha256-6xeiSeYVwzAaisLQP/Bjqlc/Rhw8JMy0FT93hDQi5Y8=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/cl-svg/";
    src = fetchFromGitHub {
      owner = "wmannis";
      repo = "cl-svg";
      rev = "1e988ebd2d6e2ee7be4744208828ef1b59e5dcdc";
      hash = "sha256-nwOvHGK0wIOZxAnZ68xyOhchAp8CBl/wsfRI42v8NYc=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/Cleavir/";
    src = fetchFromGitHub {
      owner = "s-expressionists";
      repo = "Cleavir";
      rev = "a73d313735447c63b4b11b6f8984f9b1e3e74ec9";
      hash = "sha256-VQ8sB5W7JYnVsvfx2j7d2LQcECst79MCIW9QSuwm8GA=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/closer-mop/";
    src = fetchFromGitHub {
      owner = "pcostanza";
      repo = "closer-mop";
      rev = "d4d1c7aa6aba9b4ac8b7bb78ff4902a52126633f";
      hash = "sha256-bHBYMBz45EOY727d4BWP75gRV4nzRAWxAlivPRzYrKo=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/Concrete-Syntax-Tree/";
    src = fetchFromGitHub {
      owner = "s-expressionists";
      repo = "Concrete-Syntax-Tree";
      rev = "4f01430c34f163356f3a2cfbf0a8a6963ff0e5ac";
      hash = "sha256-0XfLkihztWUhqu7DrFiuwcEx/x+EILEivPfsHb5aMZk=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/documentation-utils/";
    src = fetchFromGitHub {
      owner = "Shinmera";
      repo = "documentation-utils";
      rev = "98630dd5f7e36ae057fa09da3523f42ccb5d1f55";
      hash = "sha256-uMUyzymyS19ODiUjQbE/iJV7HFeVjB45gbnWqfGEGCU=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/Eclector/";
    src = fetchFromGitHub {
      owner = "s-expressionists";
      repo = "Eclector";
      rev = "dddb4d8af3eae78017baae7fb9b99e73d2a56e6b";
      hash = "sha256-OrkWEI5HGlmejH9gg7OwJz2QXgAgE3kDHwen5yzhKgM=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/esrap/";
    src = fetchFromGitHub {
      owner = "scymtym";
      repo = "esrap";
      rev = "7588b430ad7c52f91a119b4b1c9a549d584b7064";
      hash = "sha256-C0GiTyRna9BMIMy1/XdMZAkhjpLaoAEF1+ps97xQyMY=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/global-vars/";
    src = fetchFromGitHub {
      owner = "lmj";
      repo = "global-vars";
      rev = "c749f32c9b606a1457daa47d59630708ac0c266e";
      hash = "sha256-bXxeNNnFsGbgP/any8rR3xBvHE9Rb4foVfrdQRHroxo=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/let-plus/";
    src = fetchFromGitHub {
      owner = "sharplispers";
      repo = "let-plus";
      rev = "455e657e077235829b197f7ccafd596fcda69e30";
      hash = "sha256-SyZRx9cyuEN/h4t877TOWw35caQqMf2zSGZ9Qg22gAE=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/cl-netcdf/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "cl-netcdf";
      rev = "593c6c47b784ec02e67580aa12a7775ed6260200";
      hash = "sha256-3VCTSsIbk0GovCM+rWPZj2QJdYq+UZksjfRd18UYY5s=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/lparallel/";
    src = fetchFromGitHub {
      owner = "yitzchak";
      repo = "lparallel";
      rev = "9c98bf629328b27a5a3fbb7a637afd1db439c00f";
      hash = "sha256-sUM1WKXxZk7un64N66feXh21m7yzJsdcaWC3jIOd2W4=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/parser.common-rules/";
    src = fetchFromGitHub {
      owner = "scymtym";
      repo = "parser.common-rules";
      rev = "b7652db5e3f98440dce2226d67a50e8febdf7433";
      hash = "sha256-ik+bteIjBN6MfMFiRBjn/nP7RBzv63QgoRKVi4F8Ho0=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/plump/";
    src = fetchFromGitHub {
      owner = "Shinmera";
      repo = "plump";
      rev = "d8ddda7514e12f35510a32399f18e2b26ec69ddc";
      hash = "sha256-FjeZAWD81137lXWyN/RIr+L+anvwh/Glze497fcpHUY=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/split-sequence/";
    src = fetchFromGitHub {
      owner = "sharplispers";
      repo = "split-sequence";
      rev = "89a10b4d697f03eb32ade3c373c4fd69800a841a";
      hash = "sha256-faF2EiQ+xXWHX9JlZ187xR2mWhdOYCpb4EZCPNoZ9uQ=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/static-vectors/";
    src = fetchFromGitHub {
      owner = "sionescu";
      repo = "static-vectors";
      rev = "87a447a8eaef9cf4fd1c16d407a49f9adaf8adad";
      hash = "sha256-q4E+VPX/pOyuCdzJZ6CFEIiR58E6JIxJySROl/WcMyI=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/trivial-features/";
    src = fetchFromGitHub {
      owner = "trivial-features";
      repo = "trivial-features";
      rev = "d249a62aaf022902398a7141ae17217251fc61db";
      hash = "sha256-g50OSfrMRH5hTRy077C1kCln2vz0Qeb1oq9qHh7zY2Q=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/trivial-garbage/";
    src = fetchFromGitHub {
      owner = "trivial-garbage";
      repo = "trivial-garbage";
      rev = "b3af9c0c25d4d4c271545f1420e5ea5d1c892427";
      hash = "sha256-CCLZHHW3/0Id0uHxrbjf/WM3yC8netkcQ8p9Qtssvc4=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/trivial-http/";
    src = fetchFromGitHub {
      owner = "gwkkwg";
      repo = "trivial-http";
      rev = "ca45656587f36378305de1a4499c308acc7a03af";
      hash = "sha256-0VKWHJYn1XcXVNHduxKiABe7xFUxj8M4/u92Usvq54o=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/trivial-indent/";
    src = fetchFromGitHub {
      owner = "Shinmera";
      repo = "trivial-indent";
      rev = "8d92e94756475d67fa1db2a9b5be77bc9c64d96c";
      hash = "sha256-G+YCIB3bKN4RotJUjT/6bnivSBalseFRhIlwsEm5EUk=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/trivial-with-current-source-form/";
    src = fetchFromGitHub {
      owner = "scymtym";
      repo = "trivial-with-current-source-form";
      rev = "3898e09f8047ef89113df265574ae8de8afa31ac";
      hash = "sha256-IKJOyJYqGBx0b6Oomddvb+2K6q4W508s3xnplleMJIQ=";
    };
  }

  {
    directory = "src/lisp/kernel/contrib/usocket/";
    src = fetchFromGitHub {
      owner = "usocket";
      repo = "usocket";
      rev = "7ad6582cc1ce9e7fa5931a10e73b7d2f2688fa81";
      hash = "sha256-0HiItuc6fV70Rpk/5VevI1I0mGnY1JJvhnyPpx6r0uo=";
    };
  }

  {
    directory = "src/lisp/modules/asdf/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "asdf";
      rev = "97b279faf3cc11a5cfdd19b5325025cc8ec1e7bd";
      hash = "sha256-4LhF+abor5NK4HgbGCYM5kSaH7TLISW5w5HXYOm4wqw=";
    };
  }

  {
    directory = "src/mps/";
    src = fetchFromGitHub {
      owner = "Ravenbrook";
      repo = "mps";
      rev = "b8a05a3846430bc36c8200f24d248c8293801503";
      hash = "sha256-Zuc77cdap0xNYEqM8IkMQMUMY0f5QZ84uFmKgXjDXeA=";
    };
  }

  {
    directory = "src/bdwgc/";
    src = fetchFromGitHub {
      owner = "ivmai";
      repo = "bdwgc";
      rev = "036becee374b84fed5d56a6df3ae097b7cc0ff73";
      hash = "sha256-WB1sFfVL6lWL+DEypg3chCJS/w0J4tPGi5tL1o3W73U=";
    };
  }

  {
    directory = "src/libatomic_ops/";
    src = fetchFromGitHub {
      owner = "ivmai";
      repo = "libatomic_ops";
      rev = "4b7d0b9036f9a645b03010dad1c7b7f86ea75772";
      hash = "sha256-zThdbX2/l5/ZZVYobJf9KAd+IjIDIrk+08SUhTQs2gE=";
    };
  }

  {
    directory = "extensions/cando/";
    src = fetchFromGitHub {
      owner = "cando-developers";
      repo = "cando";
      rev = "a6934eddfce2ff1cb7131affce427ce652392f08";
      hash = "sha256-AUmBLrk7lofJNagvI3KhPebvV8GkrDbBXrsAa3a1Bwo=";
    };
  }

  {
    directory = "extensions/seqan-clasp/";
    src = fetchFromGitHub {
      owner = "clasp-developers";
      repo = "seqan-clasp";
      rev = "5caa2e1e6028525276a6b6ba770fa6e334563d58";
      hash = "sha256-xAvAd/kBr8n9SSw/trgWTqDWQLmpOp8+JX5L+JO2+Ls=";
    };
  }

  {
    directory = "extensions/seqan-clasp/seqan/";
    src = fetchFromGitHub {
      owner = "seqan";
      repo = "seqan";
      rev = "f5f658343c366c9c3d44ba358ffc9317e78a09ed";
      hash = "sha256-AzZlONf7SNxCa9+SKQFC/rA6fx6rhWH96caZSmKnlsU=";
    };
  }
]
