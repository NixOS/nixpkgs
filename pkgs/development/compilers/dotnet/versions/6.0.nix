{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v6.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.36"; hash = "sha256-9jDkWbjw/nd8yqdzVTagCuqr6owJ/DUMi4BlUZT4hWU="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-Pv/h4ZxCNv7yJZvTejTO1lHAF6zbqFpFt1DScCYhbow="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.36"; hash = "sha256-9LZgVoIFF8qNyUu8kdJrYGLutMF/cL2K82HN2ywwlx8="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-drSusw5rCrlQn/5g28ihhJqfH6Yd2UN+EdD4ogqccJ4="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-OecTpBXT0VQsHwf+T39yj8QlwXy6KJK3eoNIhosTNyU="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-F3cEY6gqw2I5KgbyCmHQMD1LmYrAvx2ws4r0pnJE4Og="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.36"; hash = "sha256-xsc2UqTttIoZOg92obrvkKdp8LzhF9R6+oNQzPJTPg0="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.36"; hash = "sha256-85ccA6HqnCfQCpmin9UYv0lf30isuwKrppPgSfZTuS0="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.36"; hash = "sha256-kMdSE64Z4JoDKgc68NeeY+bI4x7K3tuJTZwKGpOv2EE="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.36"; hash = "sha256-RQ8RG7d2B3971wrRJCHMjB3kk7K/m3ueuvsGQDCXnac="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.36"; hash = "sha256-bgRT5ir0M0cEr7X8tmB9K+2BI6ZobxxiyIOVR+DDDqY="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.36"; hash = "sha256-evRB9iMX+LXbiEecqVRpcJwXMVXSjOqbSsJmimlRg+g="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.36"; hash = "sha256-luE96plX+bF6boRsFqvZAOeA9p0n6TxYKqEK+I+6Vm0="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.36"; hash = "sha256-kTg2pFGL6ofMIxN5iv/XK81cd+g7yHaLYhplep30lCc="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "6.0.36"; hash = "sha256-f2xz4aubbw/2tR60MV+bqGW2IKaC/HJUc2DBz4ysZRM="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "6.0.36"; hash = "sha256-BrisseEs7A2LBjf9OuH+mDeNQB4ixvp5gFfuXhGa1EQ="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "6.0.36"; hash = "sha256-s48PRYUPRr1OBBTt2GK32SmljLaw7Gk8qbLmHBWViKw="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.36"; hash = "sha256-uKo7NUt/39CQ+L2Gnv4U+3XNABokHTBFEixntD23OIk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.36"; hash = "sha256-MMO5jimmUOmeguUAhey6WxRSdwEsz9K+ivdyYhyzsOc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.36"; hash = "sha256-r9MLuSCq+Te5vSpRIIW/YAJo0cDhM7FAu2RTTCKMVHo="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-qkuTdChRJFNDtcxHwXS25ReI1KPVX14s2Z/yf/EYyTU="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-CQCW9LrZw8y59dXdydmQ7h+mn5ONiEyFnJhw2xtQYVU="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-rODAZWQDRJy5LGO+VqqJ5IRzN6tl7T+XrwwvShsowGA="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-74Yylc4ciuCowWKp2GbAyzgNKHTYxc2N1Ih11+YGo/E="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.36"; hash = "sha256-xUJbvtIKkWGmnTOn3CuQZy1HmCFTFcjzBoFj/y230SA="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.36"; hash = "sha256-JQULJyF0ivLoUU1JaFfK/HHg+/qzpN7V2RR2Cc+WlQ4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.36"; hash = "sha256-9lC/LYnthYhjkWWz2kkFCvlA5LJOv11jdt59SDnpdy0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.36"; hash = "sha256-k3rxvUhCEU0pVH8KgEMtkPiSOibn+nBh+0zT2xIfId8="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-lyzlUJYtqJiXk4kwW7cd2QdekhrzWvxZc/STrwbhc2I="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-qjGQtht9riTA9EaKz4A1zmfWAhGBLIJI+N4l+ixMD74="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-ZHy3FnPuZclx1E6oOuFrW6BCQQ+xvvsLo9lnN16ahMQ="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-cPFbbwd/xLPXprmRh5KKx1Qa1w4iPeGEMEFv1AeO+9Y="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.36"; hash = "sha256-uUXt/LWQAnWKTk2QGI7BlXcANcFN4JZaJ6XJ1wEjIhY="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.36"; hash = "sha256-zUsVIpV481vMLAXaLEEUpEMA9/f1HGOnvaQnaWdzlyY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.36"; hash = "sha256-VFRDzx7LJuvI5yzKdGmw/31NYVbwHWPKQvueQt5xc10="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.36"; hash = "sha256-U8wJ2snSDFqeAgDVLXjnniidC7Cr5aJ1/h/BMSlyu0c="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-sY7I1Elol76/dENXWkbgKDTKjbyLDfMb/itP3/0Ipvk="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-2qx7jjmoyUDtwRMFDW+PguCk8vfwdouq3wL3My0gxCo="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-cHKQC0Np+zfUjlAODnGCU/a8gQl81R+ib72SKpZtpmg="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-fusHnXNyYbl4s3BEM82QFqyKEVjkcz4uOoLJXsF+tYc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.36"; hash = "sha256-X2/UzlWLU1gsnOpy4kYXuearQDrbc64+ye8IdBL1cCo="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.36"; hash = "sha256-I2+YEFVjBzgQngp358Q5nrKJbnetmOhULk39XgB+Grw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.36"; hash = "sha256-GNj25Z0W+B7kkK4FGmhDchOEum7xD4DZVOx/OEByEpU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.36"; hash = "sha256-9/LMcnvRdBkp2JtxF6UzG8y6V2a520huv1f5Phw+zqM="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-9oAK/sKdu4QMa4dG6doVjt1sKtSUM479AUgmk0Vp1mE="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-W3oEFty/44DxuYxBpqd0rFSfBC963Iisu7MfpzsGAkw="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-7L7cE2OrdCeuQQ3/V8nhzjQN2FCFqnGUSnksLSDYjZQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-OC4xtBBUIDgt7lkvRU7kWSuiiUOyJ7WmJcPdwZQD3k8="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.36"; hash = "sha256-o8Z8KznPY2NQwVrceYVjIq3VP2ORCfp5mkMHsNYTmBo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.36"; hash = "sha256-53kxmBpLLVWpdDrH79IS6HFfm9+MmUqjAqWOi3VQC7Y="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.36"; hash = "sha256-5zBTqdKry2z4IiwhXzVQh2BP6wnq0a8x5MSbHMVvCzA="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-hweGNCQA/vtdcvjwuWnSjbDZ3hri/XZWeEut6/71Q9U="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-1tQFtSQp4Dd8ZJBDO69yisowWLyKnKyB8GpsDSwU1IQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-Tpt3UYt6VPqyoyP7axfYTiL8OuqRIXyXoyINNtqQ5zA="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-5jCG5mzHmWJmgQzX7M5TWXSTPgEYB8ZE2+7CtWlINAE="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.36"; hash = "sha256-/FSPTKf9y0C6iTD1aRrvPDyQmPqYyJoyFQvhtPpWFIQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.36"; hash = "sha256-/+9nxQ7HWpEKa9RRoXgV4tOfddOcggxQNd+SroD2BpI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.36"; hash = "sha256-h8SzGkKVOcES1fNiZutPdCOoKaJ+bRdVuXO0RW6WSD8="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-otDch0L866OuthPKYnxcg/fxJnrBOk56ECyByvkWiEU="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-dCcMNeoVq2p11KUrnYdKPjbvS4bGJxjXl9in9hWxmLE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-rOf/vDU1gKDpcZbfEPwQe2pCOqEuwX2jN39JAJrbM4o="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-A2fPGTJu1VLWpukHR4s1E5htwnDrKLKbeHgEJvp7eVc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.36"; hash = "sha256-z+uVHUe6I4I/xS1allUSIKJf9ELPCnEKPnCJC8vecPo="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.36"; hash = "sha256-2seqZcz0JeUjkzh3QcGa9TcJ4LUafpFjTRk+Nm8T6T0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.36"; hash = "sha256-DaSWwYACJGolEBuMhzDVCj/rQTdDt061xCVi+gyQnuo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.36"; hash = "sha256-UfLcrL2Gj/OLz0s92Oo+OCJeDpZFAcQLPLiSNND8D5Y="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-26GTRArSWDdzmbfWTH3fodqRzAD3pnASgzL58U2f0bc="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-gn728R1s9Ww+MuHxTOZyEWF4hdNd9TDa0izNBHUWV2g="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-BwBkMHjaPIq3NuRRHGEPiMkWoxBDltIQu08XLGMoelA="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-w4rYL9E5gVFlpp7i5d0rU009dwcFYDjmwtKeedGy8DE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.36"; hash = "sha256-DCvaAW0uozr0GbDQovYN+CtGRuJNQz825ayVZV5Fc+A="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.36"; hash = "sha256-yxLafxiBKkvfkDggPk0P9YZIHBkDJOsFTO7/V9mEHuU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.36"; hash = "sha256-FrRny9EI6HKCKQbu6mcLj5w4ooSRrODD4Vj2ZMGnMd4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.36"; hash = "sha256-0xIJYFzxdMcnCj3wzkFRQZSnQcPHzPHMzePRIOA3oJs="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-l81sUE7kIczCgHP+Bjs6dClWCxNCWDj3X0qzd+B7Bf0="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-wLODEy8R84qF8RT8ngsWFd6NPAoV1kLMrQ9kzTHs4uA="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-XXEN0n0c3IBu6zeP5gtUJVITlDXEWRjAwggAaJ2Vw2Y="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-ABz0ynryB6GV/7kKMrccirnBz4OVBe192yqLHclvSVA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.36"; hash = "sha256-ovT36zWsw+JphcsfoXK0wEZB53RLRN3L848LVM9pznw="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.36"; hash = "sha256-KitXT1DzG3SgXI42P1Oov+RV2it/h7Bk7VjZdJQTkvE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.36"; hash = "sha256-lyayZigrBDFFi4xhS2DDOsKHEmgVlAzO/MN/IQw9fGk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.36"; hash = "sha256-njMZhCLpGaNbk8gTJ+qe66tFlHBGhvhUkWnng1yRmIc="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-o0T1tx0dNBlth9v5p8U9htItZhcun93IL+eEHntOcoo="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-uTdzSKyhP0K7zve5c8+0fm3qpnKe2t+myWz6VtXvLxw="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-YJVI0Iwuon7k5Mcn4gIPqJQ0HkdX4DsQRmB9J4MIncU="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-SkN10QOFalo+p58w0Wqwhe/oP8nw3YBdKVblUc5xjgY="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.36"; hash = "sha256-4Pkr3by3mDVmaTzqFLa5cD5qN48mE00kXYYPRaX4n4Y="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.36"; hash = "sha256-PCXP2vbTrnAkku+wwlyzU8g6xt5PQritF/ypBTZqG3Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.36"; hash = "sha256-LmjA9PQCK5JGmzKnYmCQ+cV//Fp4WACPpE3zPQ2crpc="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-qi5O1opYEVdtzzZ6Whv1If6M8bVcSi2sVngjBUkbYwk="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-RNcqkn8hSOcr8edcvXLi15ROT74G8yxvcHFRJBC9GLg="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-peJyUcGZOV8IpNx1s5qSjdh5pKssQ86vetSj/6jCiRs="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-CqUiKORD/gPvYnPzkTkyAStCTNqotD8vx1S8D81OUTo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.36"; hash = "sha256-SaVINXa3pwwt2aeYbGLfZHLz3v3bb1lurMYMdH3uiQI="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.36"; hash = "sha256-2UyB7+pAjAr44kXtq3QWezWy63M5Fp/TBcCmSuznAqY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.36"; hash = "sha256-+/08a9JrHj4mmAnuyR4e/L2rTBOq+EGHlpYslOr4+yY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.36"; hash = "sha256-sxgz94GMYzjAjk4BRpLPL4BGynN5RqkAiykrF7yQO2c="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.36"; hash = "sha256-FpvNndM80UP1+myb9LSzMZkjd8mm84SeBhfAPqKnS/0="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.36"; hash = "sha256-BNf/wBufKmc3nbH2TUJT4KmSXWteOkuVC1cDpnatM2Q="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.36"; hash = "sha256-DFDy/H/jzOpZHrg+3ACmAv94+/s1c0BmzpeZehcpmUc="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.36"; hash = "sha256-88w9dRrFvNs7kgyTbQiEHBAHLgUX0/m6tJKkq70uGIk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.36"; hash = "sha256-POEV0LZdV5aFbFX5DO2aBH9iS5cdlelMydV16/b00/s="; })
    ];
  };

in rec {
  release_6_0 = "6.0.36";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.36";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5a1d54ad-f01e-4407-a413-493a5e81f802/9773a2ed4499d6d8c2a89714aa3d9c4c/aspnetcore-runtime-6.0.36-linux-arm.tar.gz";
        hash = "sha512-UYbGVPvWSa8HYL+zvikyjfKA4E8hKMUxV+bFUNBrMZcKUIrCXMA4yeGxKdwqPAAlmXOcj63TgcuIj2q70YjOXA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/19bb2019-9acc-4c85-a397-5c84aad3e79e/094076519c27db7d2619aee8744c9eaf/aspnetcore-runtime-6.0.36-linux-arm64.tar.gz";
        hash = "sha512-Kmot3nujru6RRWhu4y8ZAaeqYjiug5XqO61Rdw4icGknK+g5WbcR0jghDDd7ZmYePPA5ll8Bm1jNRMCKmCQEog==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f4d628c-903a-4c54-8e78-584ac3fad3e9/35c386c099e48775ba50df7bb3dfd93a/aspnetcore-runtime-6.0.36-linux-x64.tar.gz";
        hash = "sha512-Dj0dzHFb/7y4q4y0/XKsy+7XmsQLf9UXlheXoWj0MBUFBE0sFJSkmw5oEDlAvWwXjIrnus919LQM6CzIViT2vQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e2fbcaba-7da0-4d87-bb1b-0b78e53a9d86/9c695640f542279269b0ddf23c27060e/aspnetcore-runtime-6.0.36-linux-musl-arm.tar.gz";
        hash = "sha512-D3cnNayscljCr0pnyIHVr6wvhB+atpGga6HjSr2B1YMdCf6IhuAl99H76Eoek0FfuONVEcS7mI3ZTLgjwY0AeA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/52842791-2dea-4278-86c7-4f1d4a45c0e0/87ef463f7e608b9d239066f02d09098f/aspnetcore-runtime-6.0.36-linux-musl-arm64.tar.gz";
        hash = "sha512-zz28aHrNJyIFYLr1LVLdQvR3Pd1kJIeuhOeimKww2WQK+GzQxe4o7NA2SzWJIZTb39HfMCRRNn10csO9ACAvJg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2fc024a5-bb7a-4860-a38a-89248a6466f2/95ce83467434e681a3bd771052ffbb91/aspnetcore-runtime-6.0.36-linux-musl-x64.tar.gz";
        hash = "sha512-GNM99Ai34h/L2o4cbWfnRaN0Bi0ZVGeoJgMtpnl4T7MLVf2tLedUl90OkXshPXiM6z8bNIEnbibhA/mRx1U6kw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2271afcd-e427-478e-af95-bea3ef119bbb/4a4d713978ad045bca1ff93eb661611f/aspnetcore-runtime-6.0.36-osx-arm64.tar.gz";
        hash = "sha512-w7Vp9gCgL7NUyFFnXV0/0m0/h1n+mp9Ffym4MWxa5PtHSE81S5oV81CMlWHP3zbb34r5kUTjEDotnVhYG34CSg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/daee4540-b60b-478e-8ffc-37c8798ed6bb/85267ac81195d92e6f1045e84e8a3baa/aspnetcore-runtime-6.0.36-osx-x64.tar.gz";
        hash = "sha512-ijtzt1xboD7gJZIWOYJ4Bblbbl5ckgxUT5Z2m8BONvS1xIB7QP7AwdbRqCka+vb14a5ejaiR1a2R+O5IQe+Pgw==";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.36";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bab6b400-38f6-485a-8ca2-a2039d7b699a/87ae685d9df812b27be2af8b05ae27eb/dotnet-runtime-6.0.36-linux-arm.tar.gz";
        hash = "sha512-8/kZmpfbgdPj7SSeDpuPF6+3hei5660AAWV2OC09DyApox6vdgviUJ/eeWpC7+tyexVkiKQvSMwIAT+HR5ys/Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5aa79fd1-fac6-445f-9e68-003a0d368656/f21c1d45e64633019645d164cc53cf5b/dotnet-runtime-6.0.36-linux-arm64.tar.gz";
        hash = "sha512-qpo18YEgQZmsbESGPEdz+JZ7Ja3OIY4jzigitAsmw47cHk4v8yPau4GuBJvBh/FNIJ7xNl5olw/WwyryHwodRA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d0d7fabb-4221-441a-84ae-e94f59c8ab42/a7cd6251bd8ce5fac4baa1c057e4c5ed/dotnet-runtime-6.0.36-linux-x64.tar.gz";
        hash = "sha512-r7YBj8q+xGjM164vETHYyd5/TedkW48MIj77vb/cUV+wZCo5nr/jcsAgREFsTK5GPJyALNFWudpBge//DjPulA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1befe57f-0495-47e1-b6d0-810c47dbd777/c15062a1d53a086e49994356647f99f0/dotnet-runtime-6.0.36-linux-musl-arm.tar.gz";
        hash = "sha512-PdU5gWQF7C2Bj2EafLmP5AaZYOisRmTMygT/iy4GeTh7Cj8sxQRb75VldiasEEW+3E5QLaME7lRnivu+g9zDsw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b03f2676-0841-4585-b18a-73c763ea6e08/f392aa52226cb0de2f5e2402af0b5a70/dotnet-runtime-6.0.36-linux-musl-arm64.tar.gz";
        hash = "sha512-CDBxVRGrYCJCSHxfrg3HpbdeDJ13BeYkGB7BPMRyagbXk135Uq7d2g3CxG25WrFK+dgimiMCsebS/X6JK0Imew==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9509eac8-2788-4fee-912c-edbcc9a87c40/e8073d775d1c6be5006aeba81b024b18/dotnet-runtime-6.0.36-linux-musl-x64.tar.gz";
        hash = "sha512-VsIWHFKQFwb9dp0skWjP9ZWVdr0actiffCeFj0Z/WZcGJOqaBVk2hGK8F458nvfYbQ/aCMfb23LdPpCEKAgj6w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fa2cef0a-6107-4aeb-9a45-a06a0329d56c/b9d386983e3f1d7570026645d9b7158a/dotnet-runtime-6.0.36-osx-arm64.tar.gz";
        hash = "sha512-0T+gYCcMN2MHxwhtpSz/caAvhVCjohgS4lEnMIlwyZoy08SDTjQvIzZYaWAMC1H84DI2kG4T/nZFb8eJZMUx1A==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4aab6108-c6f0-4b7a-b1b0-37f6b0fa621c/122b1b42895150267dbba61df69a2455/dotnet-runtime-6.0.36-osx-x64.tar.gz";
        hash = "sha512-gSGpise8k2B0wuuCqkXa4bqHRciAiHD/tAAwKiZ99xv685Tlxic61sei7ECHQKs2mgOsgK/y1JYhrhMfdJCtUA==";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.428";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e1f1b444-2b24-4ba6-a1a2-f669f6710127/45371782a57b927e6dcccdb02b04d763/dotnet-sdk-6.0.428-linux-arm.tar.gz";
        hash = "sha512-x1GIHdJ+8JhCjmFrmanBbov4JSZIT3aYfawe/LUXdTR0nI+UP22dqsw6kbsIbJy5yNU1yYgcC+PcGcZHBllo/g==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/63915342-f75e-45b9-87c6-26191463df72/60c45022a869da1ad03b8522b0c6a7bd/dotnet-sdk-6.0.428-linux-arm64.tar.gz";
        hash = "sha512-y4RUhl7Lmc5Ve9CldB09yEZXpF6gD5sqDwWT6U5OZh6JilaQ35DPAXW/WYKXPBmYWhaJmKqpdbesejvvLs0F0g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/35b1b4d1-b8f4-4b5c-9ddf-e64a846ee50b/93cc198f1c48fe5c4853bd937226f570/dotnet-sdk-6.0.428-linux-x64.tar.gz";
        hash = "sha512-BDlfmRq1DkdVzhrlPiNZKnQgtxuCFgiDuuMZTdHf1dyu14dD5OC03VHqQ8SeyEtWQ2MHB7OFTxRxJl3JhJDS+Q==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/83abc3b2-9067-4e7f-ac36-7959f99d65c5/58aa206003f1154d89330807e01abcdf/dotnet-sdk-6.0.428-linux-musl-arm.tar.gz";
        hash = "sha512-7IKDms8S0mxo9l36/JRlBosj/vUJ0yA+fUkOdwGiH93hq2W8mCcrU50UB0s6IGaK1yrVIUiSH2HBwi5/IGhTGQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/02a81002-95b0-4d9f-a793-7746721af662/4499ab2facb3bcd4b69afbb9d8c499b2/dotnet-sdk-6.0.428-linux-musl-arm64.tar.gz";
        hash = "sha512-Vq5UgLEIhmSarEu57x7kpXAWOEg/Nmt9T0MQiDjdnfjgGZIyGW2uHdUAx74+F1zm3iZBodLgeN4tEGzLRDQsJw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4e413418-c590-43c6-8c40-da0dcf4a3b19/7fb8338dd6c4d7a9ea109f7cc855a953/dotnet-sdk-6.0.428-linux-musl-x64.tar.gz";
        hash = "sha512-9XEj0UZcywoVM7UdCZXFE6vrD/wVeIv/ivQUTg3TCiZZ20G9KvQyitY3WIFW4uZJoFGCR+79+JQkA5OUZlYXhg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d1157cf9-cf63-429f-b454-b1b46d467bae/05c67926367cca5194a838421c6a9e37/dotnet-sdk-6.0.428-osx-arm64.tar.gz";
        hash = "sha512-tg50tW78W9sFvpyVS8pv3bxrqnkhOxIP2APHUlLFTPSm9FJVtTLBjOroxMHCpg0nAjCRVvmrFDa9cfaJR8NyFQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fb84beda-bcd0-4e87-a732-f51c98d58a85/f0e0bea82ed83e307a56f4cf2aa496fa/dotnet-sdk-6.0.428-osx-x64.tar.gz";
        hash = "sha512-/9bTQsxwDK1P6P1qKYltVfi9f2h/XC75rmhEnDwc7kiX0jGFBQdbqyqSU44NuGBd8TVZkj2GHZEjulnF+w5b0g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.136";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6e0841de-3911-402e-8340-171026626dc9/8655b8901d68e0e961c8d8fcc470b08c/dotnet-sdk-6.0.136-linux-arm.tar.gz";
        hash = "sha512-9OX+Kr1HXCLtSExZSA62DXqCZm+bcaTKNauwgk22N5Aar2Kn3v9Q5mnZ5g+AC4JzlsWxu6spsglFWRQ5bAemRw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4f4db241-7548-48a8-b28c-bcc18a257518/4e183425102461b9a6749ae2dc3626b1/dotnet-sdk-6.0.136-linux-arm64.tar.gz";
        hash = "sha512-UWgk2Ccq3mcPzC3Q7jMVSgBzi17qst4VMu4+BSn2cKblswpVQjrnXwK9SquadSZL3ez3Nb4DBdO35/tml+yPFw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1a13a47c-87b6-4a2f-a91e-b74e6a6edddd/c046ae1b8352733c5184797cbf8a3739/dotnet-sdk-6.0.136-linux-x64.tar.gz";
        hash = "sha512-v51aSoho9oBufEorE9CB/JwKFHW1J1HKIRvIX6ogA/v2PmWOEViRH/H+Jf46q2keWiGBsU2pGckRT/3LmzyQvg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/de3eef37-e90f-4b30-90f7-5769834ceed3/b122c8eaf09a128299c8a7ea0c2dbe55/dotnet-sdk-6.0.136-linux-musl-arm.tar.gz";
        hash = "sha512-7bphsvCisolGpuOJE5sWgJHbkiCqdoExD7k3JB9gIg4TdD6NabHuY7hVBLEhVL0z/CushX4Ww7qeeuI6DTNrPg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dc0bc4ec-c584-46cc-8f35-a1868f71b0dc/3271ad62955e098403bf5494e606c712/dotnet-sdk-6.0.136-linux-musl-arm64.tar.gz";
        hash = "sha512-LMtOWPnfoKCdzhaHpgrkkRz4yGSr/H1jzcETvSKKJT+VRdaZ6HCdFAP/KM58+NsJNeR5awWwqoDu9q5D04uFNw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/93d00c94-9563-4e96-958e-2c0fef32ba85/7e74e55e727fffd5df6af22bf9050e41/dotnet-sdk-6.0.136-linux-musl-x64.tar.gz";
        hash = "sha512-qTuoRlAXB4CMa46lGqdj+vgswhUyWqMQqgXQhMrr0sQPdASLOEYkpzmIukGL9ypxtXiDwqBaCgh6ES0sJrQmbQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/86c26bfd-913d-4ab0-a2ab-ac71689fe7cb/f3fe4760bed2f23ca640bdb6d91a634f/dotnet-sdk-6.0.136-osx-arm64.tar.gz";
        hash = "sha512-WDHdExldgFswDls1vdipJdX1PxElIq1BjMiwdTplBiaScxUyHM2QJH31JYJhInEldpjBTlLybRsyFmiHMMAXBA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ff5a3bd6-c252-48d9-b5d4-184ab0e7f1fb/d62375e8ca68b829724f04809951a478/dotnet-sdk-6.0.136-osx-x64.tar.gz";
        hash = "sha512-oPx4hnx69+O37NHTeoWKLfljJ+8AWseGU3oZQD+wElGrERAjGWcLGedrNjaj/Qjl6gEzlkPQagROF1LRPvLK2w==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
