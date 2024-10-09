{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v6.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.33"; hash = "sha256-GcPiO+iI0JsHYlqURAmzWjOnDX2jDCUY4jYaIwr8ojs="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-SboOaKgRAWf8Ce2mb8izqvTxGNYsKAbgNIDGmdwaMpo="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.33"; hash = "sha256-BiGUcXo1FQTlZdR6ndhUQ8lrYG3KaGXNXRVF+Fc3L28="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-tkJtIwdMSbz4VNyTnz/HQcV8LuN6PAAiN5p34aHhSog="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-Eo22rJu2roKFD85Fme3hSYqoHE2YdehHAW+kTi0J2aA="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-LOwFh6fozyRwqvP2CBt8JaSsrkNY/D0kHcXlFP/uvYo="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.33"; hash = "sha256-pMY7bdG2du0Lh3xpAUls7WWAzqenMwlvw3tmtkoVmO0="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.33"; hash = "sha256-BU3yVfKE2h+dHUQcqhxOOp8Pbdwbm3RxPy3/KkjtBMo="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.33"; hash = "sha256-4YrPHTlKoNvCgmgKvZx1naRQBiFN81KMMaDQ1VW52H0="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.33"; hash = "sha256-pECdxdP0x1buwSaxZpioR51ORRl5BokV3JXUb23kGoI="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.33"; hash = "sha256-MOW9RvWvQbrFIehX3UVdZjhoQz46uj1m0oIJQlwFKUE="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.33"; hash = "sha256-R9TbY5HpSt1R08xB3mmxTWZE3TBFeK4bH5BLUCyMQ5c="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.33"; hash = "sha256-ArfQKZst3BbZ1J9I7Rmdg4aehEYWY71jG7bOkMot7BE="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.33"; hash = "sha256-fBfBkKW/nYwFsO1xd0u/nOIZnIG0CGW/RE23PsOQeE4="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "6.0.33"; hash = "sha256-c+3lplcEkrMapHA+nQPt4v2IkeiAvif6u2Ux32V5Iy0="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "6.0.33"; hash = "sha256-qHleUXickhYB1CIWGWzsMB/BX61fuJXcVchkuKAOwLw="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "6.0.33"; hash = "sha256-wxAzeoLe47TV5GWXXVWRyC+AKqBuTJ79RqS0DwqJpGk="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.33"; hash = "sha256-9IIvr+MVkup8SygTV0HIHObHQt7gNAEj+0kYanmJ83Y="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.33"; hash = "sha256-ReYcVuhM8+it8FhEWNM+HLTiRsJi+8Xauscpus/uPQ8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.33"; hash = "sha256-NMTRG9jt6aHRuHKQhV2P0ex194t1FM0ZXkQBEdLVIjk="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-LKtXdCHaIx88J13bSmANZiAGgYyse8qtha+pi4LPwMQ="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-e9KR+J6yBSp6Py/xkrW2Mtc2xW84YDZ/4KFJPY4EkEw="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-x18Pl1WygIEU75poeIXlcP3ZxdrS4nRRJ/K3lv6mfyY="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-xMt9SDtZ9SlLQpy3GJKx/SxfqGCKIk30HFhQ8HpnUos="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.33"; hash = "sha256-E636XnOUoY2BQP1HkUCGWMRCupjVeQPUVxIiqn1cqm0="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.33"; hash = "sha256-g5zbB1DnCSKuCOWtF09GEqGn1uJLdlTN6kqdnSCzRjQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.33"; hash = "sha256-rwWOpf2Pdg84c8bKIUcMYuDTI0kXUELL/nl9psSmX+E="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.33"; hash = "sha256-obRKiJEVpZ5E3TE7q2oHaYwFYhI23rMiHwp+8ORkwXY="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-GLQ/7vf+kqHLu6yeiSY8rq5yPUmZvxKtQ6HRR8iRV34="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-oXlmQZ93jZaq7gj8q4MCXWpx0MxKuHhON2SPE44o+ns="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-/skm1EA/eVeK/Fedra9Naavck9mkWXZdZTOw+/oFw8E="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-mLZz9Y4TzJHjsTMemYfeXXHHqG77rXLSOxN3r7bpd48="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.33"; hash = "sha256-9oS5Gf9E74c3xG79oFKMoGbHmuuH03QT0CEWu8Zrmn4="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.33"; hash = "sha256-ToaiqVy5qonomAVBg5PO1GgrPKL4Cc1BZTJ0z/2LquA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.33"; hash = "sha256-5iYNZATXOePDsLA9lI80o1Gjxw4E+B4bJbwdYJJHcZY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.33"; hash = "sha256-2xdhvnKsFc8utDWN09zeXzZ5op+WUqkoWLuzdtQAkrA="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-3mzU+lDVG+8TqO3OoNnDmj0JhQCuqNxpS3PDvj+3WCE="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-m+m6kJGKBSYKQH7K+FZWT6eY3TDkRsbgy5QPxymhWhE="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-ueIBjdXXdDBHHVLndlCXOu4h97BTChMHE2xOGqtdaHQ="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-PojG+X32PbRZTuGYnAzvuBp+gxR20Vg+Uk2Zj264bsI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.33"; hash = "sha256-mTvhLH6NynlNipMtUToAF3C63rzubVrvaiYo6OqB61A="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.33"; hash = "sha256-DaKK9vpjByD/Pn9L1BcTufbHHyzX5R2NnqTBStv8nUc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.33"; hash = "sha256-g/3W0QDx58TsJCHinDefR5EzVD3Dp0cLVNdXOTdpGIc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.33"; hash = "sha256-wrY7taxtG79TQfQbenMCYVzWdXZm3UWN79OX7ofM9G0="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-vu0Prhi85qQZI4/C8xlW0M5sAxlS2l87WmLRn+rugo4="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-4x53jrWRUCzKBK6hY6gFFL1xNXN7rqlyf4V8bkXVOLo="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-8AYUSNze/g1Ji9S4gaZ7oYppAySnUXnjDVlm/O7jNts="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-4it4ArciHQ+N1Z148mc3hTmb4p/X2PNUBGcGChuqEFk="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.33"; hash = "sha256-lZCTehqxeLYENhg0CuYpYO6GY3/tP1UCNnJf9MddrRo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.33"; hash = "sha256-VnJaB1pt07GDdmOasNpOzMp7Mkiqns7t6as4cSVmeAY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.33"; hash = "sha256-3ya2Hio+/UB0EdRLwuQYFu/ZzAmKSZFor5QJ+D5jyXo="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-/YQTVPObD9OrhU5dQV3dYM+zBuLwpvJrxbiv3Nj7OoU="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-XqVPPIwNmwnSBrObqg2PgAotqSiFHL7In+6oB+hz1ZU="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-H8dMez59DOTiUuxbV9QVkGsE2nkgI0tFNlmzHfXeDag="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-YXt9pfVsqOZid+STshFAEglcYgjievWquHMGqWkhZE8="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.33"; hash = "sha256-W0SgEXUKeOoZVPUC5fpHw9zyyfydCOdPPxHdF5Xb3b8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.33"; hash = "sha256-Lf1TDP7q5JqeLLTTNpm9NE/EGKedcFVrFBtnukqreRM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.33"; hash = "sha256-FvGON+QxJq7/U3lBb2xeQZttUmxfi+WH2eqt2Ya7aKE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-SPiJX2RUYD066ReIvEk8mj9MIIEQOvWRIjDE0w4eGyQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-OMJo1JDbTGuWDRJbmgNMPK1tyvPya8OB/PYKBGFQMek="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-vHZltBs2GcaCi4J6oi1atf1qLC6ElWuU0aruO34ystg="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-S4FD0SnrgsfXju5xFyizsQn9hf6DYiREqKi7baNabf0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.33"; hash = "sha256-uxZDZIk6YNlnwFF2v66vu+bdx4EtcGB/TCIy4Yuv9Uk="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.33"; hash = "sha256-OY/vdqAzZ99I4lEZbOOQw12TE0AIb5pXxKTvDxO2M2Q="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.33"; hash = "sha256-k3LenomOlacyzq4FlBY/TwV7+ClbK4U0A/O9r0pZHT4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.33"; hash = "sha256-9KHubWicibZOcixiByzuBKPnJM2u5DSQC9jR3MAR1bI="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-7SWFzAlSSCnUbrBtHFcSXnRnfhbHVYjWFhPdeYD7kgk="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-X2xWlIbN2GCuHyZtENOWtiI2oyh9YsCbNy4zyHVgDEw="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-oJFf9OyPR075rnWA3OTkL9yXh+F97l7fA+EoxAK9TCs="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-cM7z2SJoZ0vUVZaAFzZsr6LLFT1aB/FgaFEnPmjaQmU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.33"; hash = "sha256-EuMc9QvSFCK00E6Ic4ggCTBfElaoTMTpdho1qA9Dcw0="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.33"; hash = "sha256-53MAV3RO1kXzy5IpdZDZIOhoUzFqWHn7+A3aWwdTONQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.33"; hash = "sha256-tu72AwDH1+oAIXjOJcNbeyKm1s4pncYp0avbMSBrcJQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.33"; hash = "sha256-smh6SiTtCAuFglqWrXiGGsoIDP9dhGuIKdYjmw+xCyY="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-XHypFT3BZS7yjYD4qrktW+KB/Vg9WO3GlVpQiZkbOiU="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-9l9tYg70D7bIGmANOnoVPiehm0R2FOKSryevw9ZSf/E="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-wP3mcAnXnfMMz4eW1NX9GtZx1V29+OFCdlsXBDhznks="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-n3vRppIStWqCc+lf5vegOoEnWQo39/lmS2s+iBqQZ3o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.33"; hash = "sha256-DI2FvmRB+YAKqE+TFSQAnFPzvZf20gJl1kF1LdCD7WM="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.33"; hash = "sha256-I2cXLq282Y4Hqwwb4j4UIpZKzwdbzGV42LTzTSQdemY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.33"; hash = "sha256-wP+GUxx6dtOt5ZExByyvU5zRuznGye5LPisgS6/7Bm0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.33"; hash = "sha256-lIklP4WcYw09ZfEWj67YQYAkMM6G0na9G3Q8SRg0K/Q="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-d4YXZ4+nnv/98fIBjd4VRKISbdFQSccwCENFPmg3JRg="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-T07ezC0o0V648IoVvrguWMxHyowEGp/ZsuixGbpazes="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-PwhD8MxNS+YB7+bS/TqMXXCmqMWY8rt4ZrqmtsnX7AI="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-ay71j8SXGK3rLyja/ggA/5P8UJpxB91DOkuIeLEDMlE="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.33"; hash = "sha256-UjItoakBkTBGTMQU5TC9xFbt4imiLnwotTx510VcMYA="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.33"; hash = "sha256-XcJRWTFQsBWTqwwQlo2I7NUsxcTTyLjNJqgQJDEyj2U="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.33"; hash = "sha256-S2+8yeI0ahzgbpStXF8fQ06oaqkZ1AKHt+bCBnml+wY="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-uZLgWv4QJCpPz8hIU/RCuTpdyyl58Bjk8/q84j6O7P4="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-K6VhsUdZ9BCUG2cehfFTvceLCEqQUEuBOKtIHDO9i+M="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-DFpoFsXJSeSoTjb0m/ZVAy70FnsWjddFH0JuipZ2zts="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-ktOtUmKwRSgzKBctyvmrMOlYppR4xzN64UPWajq/3/o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.33"; hash = "sha256-QQ12AvhNi3LzYilmNIrub4Kd4/vLaSxVLdJyDHDBxeo="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.33"; hash = "sha256-7/7MpglFhvZJb8AaNA4zDQm/pgRPbLEUkAOnDOqhz5E="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.33"; hash = "sha256-OybB5ATvnnPEsKAdn5a/UdjSPcT78wlf38YNmuRWBZg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.33"; hash = "sha256-jso4iQqVeEXZNeofbxuHS+wva9pG/1mFPYzIpYx/iPo="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.33"; hash = "sha256-raZK4I1xpCglN63I/jSRLfY4EkUdhqnaOzRPjD9BLgI="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.33"; hash = "sha256-QzMZjkDauMOrs1ZbN/dOCQlUpgMrGsTCNAzT3evupW0="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.33"; hash = "sha256-Tx5FSn8m15qjJ0Q0JcrnRhujGgV7WTr0btNviHMKe1I="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.33"; hash = "sha256-I/jbwabthRKpT7olXuTgaIRTATapDS4WgbUgA77Hijw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.33"; hash = "sha256-24iKtiEYCAQLmRxRUfLBgwoq4Qmho+Jz5VvXr65StbU="; })
    ];
  };

in rec {
  release_6_0 = "6.0.33";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.33";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4ac9397f-3f4a-4cd0-aba2-35e7f1b47396/9823f50c32028899f430bc3ae87251b1/aspnetcore-runtime-6.0.33-linux-arm.tar.gz";
        hash = "sha512-f6jM4xyaoMg9/RZ7ehFsi0o00hsRVO/HgbwqOMFNNQ54tbnub7jjgU5k3sbJLg8r9cXMmvkMc+o4zLZlQGBBdg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0c5a5f3a-881e-4ceb-a334-c5e3b210eef8/9834ffebacea659cd14d272fb01f81c4/aspnetcore-runtime-6.0.33-linux-arm64.tar.gz";
        hash = "sha512-emCnejBgcKO5TbGs+nOTi2iAzQeb2sPlyrF0pHr0Z7kgjp9B2OEuCAgx1SgVHNqltmC+papv5TfsFEVDwP/9lQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/91f66f75-bd3e-48f1-acb9-99c0da753f96/42c47999ee4c4d108774536afe5da160/aspnetcore-runtime-6.0.33-linux-x64.tar.gz";
        hash = "sha512-ErNP4dCmef9j20vwAqKYgZTZ5k0OEH0SjCR4Id2Tmobs7Q/kU8BjjTdC2sOjLlM3ksJimUAPtP1VZrdRd+ZodQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e9b663a7-2199-4111-b18e-5ec1f2f2f87e/1746ce0319914f58806f523c6f6ed24d/aspnetcore-runtime-6.0.33-linux-musl-arm.tar.gz";
        hash = "sha512-V0q861fybhX04s60g3Zh4ZLECJhoSIDgeLitTPyPUG4lpQ883HJ24XqVVuleK5LrxtQadKZWJEGA0nNBSFqc6w==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a4b5cbf6-85d9-46a0-b698-aaf3cde78d34/e1d46fec4ac226e170ccbacbf111d911/aspnetcore-runtime-6.0.33-linux-musl-arm64.tar.gz";
        hash = "sha512-PaV7PeE02zjxcJRRjRZlM1ZJHPXWciKyw31yDsEAZE3suPs62NymRRNO+6e1e/Faol/oS5oScRqoDH3gxghhtA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/94348e55-d279-4667-abf6-00a70cfa4773/67a06176a4ac8fbab11013cd728ed823/aspnetcore-runtime-6.0.33-linux-musl-x64.tar.gz";
        hash = "sha512-9aQ7C8HIMv1wzfpP4JhJYCdggxEzokEvX30llJbM0NxlmZunek6NSwanYUuFHUeX+S1cfFwcJvOWQrde3P8Twg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/74fa4afa-a6d6-4c32-8ef7-fe88148f10cd/c887bff014d198532ba942988cba124b/aspnetcore-runtime-6.0.33-osx-arm64.tar.gz";
        hash = "sha512-JqLx1ss++d9barwW4CX8Lprto4a12lNCirrmfXb/AHvJIa7GDP+Wddu3KR23t1xae8qttU6MBN5ZMIsC3ekkzA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d4641b35-5b85-4250-9913-0f6a2c276888/bd8483d09a767f6c19f9274da2819624/aspnetcore-runtime-6.0.33-osx-x64.tar.gz";
        hash = "sha512-+Nzz1t56NNf7QC/R3fVb2BDMy5WDHRIxK8dgfGx96KRiAMZtfnUyUBA5Yboul/pqhSBrSUQuGuqx4pDsabtVxQ==";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.33";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/19a5a6e5-87bf-44b2-b7ed-ac44e9a253b8/00fca686dc0139022528dbe5f6e0f0b3/dotnet-runtime-6.0.33-linux-arm.tar.gz";
        hash = "sha512-wzSbHJi/jQt50NPeXBJ5L73UrvHAS20MEV1aplHP0uhkJSEXCzEtsMtvrNBXlYs4fGDrauW4KOIlAwDvvW8xlQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/694cd8af-7e9f-4161-8c1d-1c9a7b1d074f/d3a8dc90d971ec4f135f6452c176dc93/dotnet-runtime-6.0.33-linux-arm64.tar.gz";
        hash = "sha512-xwDUrj42H6KjkKj88pSiJ3kxsOpgvUovDsK7mCu2xhi6AC5ZVcPuloByB7JW4QKJzxz6NyApt1iu+mvxJo1F+w==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/250c78ac-a53f-4679-ad2a-cc31fa4c4001/204b39eb9634a8dd9f39cbcaf56030f2/dotnet-runtime-6.0.33-linux-x64.tar.gz";
        hash = "sha512-CJIBVUTYkDmZ+OD62ra0uR6xgOSV+l42wadVsdQuE0hYt72/1g0YgGUNnFKNB+MbnM/HPmUOXYkKlVkCqJE5zw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e311cc4b-e2a4-46ef-8f0f-5996ac64e6d2/0a423f3d95284288d08250ce9e34ba06/dotnet-runtime-6.0.33-linux-musl-arm.tar.gz";
        hash = "sha512-qVlKSJ+GNK8B58YKyrX37grFRLmM5z7mcTWb7Nb2sp9NnmTf4xZoIsBQYVdzHsRPptsCqL4bF6J5r2GmZ5z9OA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6c147b46-cd90-4412-9df3-ca84fe040261/d026454e65fe16a83590bd75f139fbf4/dotnet-runtime-6.0.33-linux-musl-arm64.tar.gz";
        hash = "sha512-5XB5cLKoUrgLH9d6OIPlDeySXZHriQEsFm5KRekXBkwkBApuREsFR2cDPLm56DFLa1EX/62m0kirf5DI5A/lVQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/28d86acf-06f5-4bff-919b-28a26264591b/452ad01a142981b4ee4fd55b97117cf7/dotnet-runtime-6.0.33-linux-musl-x64.tar.gz";
        hash = "sha512-O/5Pnd4Cva812wcnHPVoc7UIwyKTGLvn1Hju2FVBftOUHZ2ajt4v0cxc5fe3PE5a5GZtLMR/4q4J1fhiXEbpgg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/aad5df88-c193-4579-b847-633186659a2f/1688cb1838ae0f0b67d16f3ed808f566/dotnet-runtime-6.0.33-osx-arm64.tar.gz";
        hash = "sha512-ldDmRvaI5vRlRWJd+uRtgyXHruRmHT8OWQRKzO2cYZL/UVJDVWluj4aOvREumgNtAclR9ySdhjwwDQfBoJE9Gg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/82217487-71ef-43cb-8678-d293b802b5a6/cfe49dd7b7e0e3040d4fdc9258c61dde/dotnet-runtime-6.0.33-osx-x64.tar.gz";
        hash = "sha512-oK2B1Ls2HZHtx7QhQoKPtaxbdTduatATf38ou6XA0LaMZ69wi8hcFeu3qsX5jfIL2DpWFEob+axa6vXK+E5BKA==";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.425";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2ff9a08a-9a84-498d-83e2-82e3e3c3d03d/64b283f30bb7df0260c8a7596dfcdff4/dotnet-sdk-6.0.425-linux-arm.tar.gz";
        hash = "sha512-4Muzo4dP7HYCbVzhGs2uB6cg6wK1AMh4gqrrpI5uwpDWI3PlG1M2fsqqG9S9dw8soaquw6hJm90cEUiU2qpNrw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ec8e29f5-2fbe-47d8-b0c5-81f11434c00f/ba4bd30be448d649e5ddf1991bf76252/dotnet-sdk-6.0.425-linux-arm64.tar.gz";
        hash = "sha512-wV+VZk/QVw1bDLlMeva7pf6DBHAATw6VjknVN2RxTL+N3WILONSHtgon2/1GepVYVqqz35yVjN4XyUIHn9qlWg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f57cd7db-7781-4ee0-9285-010a6435ef4f/ebc5bb7e43d2a288a8efcc6401ce3f85/dotnet-sdk-6.0.425-linux-x64.tar.gz";
        hash = "sha512-oEt1r3xYUCOKjZmm9gs3dTRn22FYMbs4M8FK7Ib6otbum4ZDiFeYkkoB4orP9ErJ7TnIn3y+U8XLh1PIAuhQOQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/04bfd229-7d52-40dc-a5eb-d31fe15fbf44/639e3b8aa8616ad25515bfe36faeb2c0/dotnet-sdk-6.0.425-linux-musl-arm.tar.gz";
        hash = "sha512-xZ6g72yA+AkHrqIj3Hqa1pQxseZyNN7k/uD5EJ7nzovVivaxAq0ReIn04syO98zu+absgLEFeMbqS4RBLyseBg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b5f55496-6494-45bc-9ba3-7aefdefb4518/61f15988a48d429bec81f5c5307f01d9/dotnet-sdk-6.0.425-linux-musl-arm64.tar.gz";
        hash = "sha512-1Yqs5bAh/HMKDaIjPoXjrkcyVqfekzS4kyzC4NBQVDwesbFtzTR193fN9Z5ClxyF0n3vSX/lzwamtgRs6NI+xA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c94a92f9-153a-4620-844c-f964dcc7eb8e/ad7baee9c9ed782a5c9ad34509ff47a5/dotnet-sdk-6.0.425-linux-musl-x64.tar.gz";
        hash = "sha512-zZVyNYECuCFIdP81O76Casm6Dw0m1JST8xKoo7x8D6ui/IK9Xft0AonTJC3N94s0GZbThiNyPGkb5Gk3WnLfng==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/24192716-57e3-4e69-9950-7840e05053d1/79398f054d34fb3e424c029e6d41a551/dotnet-sdk-6.0.425-osx-arm64.tar.gz";
        hash = "sha512-c4OxiMhQCrhiXNNPaffsWk2f9MpxX5XuAg8r0ILVAjaXsCHKSzseageC+uL/iVhuVB5FT+2s3xxJtC9uR9EgEQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ce410b9f-c7f6-4180-a373-bcb6528a0778/448c9df07432b5dc62d08868ccfef62a/dotnet-sdk-6.0.425-osx-x64.tar.gz";
        hash = "sha512-V1fGYdgkCGgKbkXvvKJgu52hRb2D+CdSgOm6dWooJ841x653yySOnubGz0ZzDG5QFSuYwKCCwN52T15SLftsog==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.133";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/af2b3ac2-cf96-4087-809b-60192e8564d0/952e49c2581e6c73d6229c2ce14e994d/dotnet-sdk-6.0.133-linux-arm.tar.gz";
        hash = "sha512-6Ua3XNGqu1M5mqv6RBCC2cwPMk2zcdlgeSvPWrZkRaFjAvEfkea6NMaZpr7WRe5PF87FXZtxGXJvABEADixuNw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/759c84b7-4d67-4eb4-94c6-0214d150db31/aea9ac1878560278c50174ee213d88c6/dotnet-sdk-6.0.133-linux-arm64.tar.gz";
        hash = "sha512-aCDWLO1tl3Dr02Z6ZKdOIklHHuWSDkzkEB8h5VlQ+NROvk/78gvGYmD9XR7cXlNKbwtwUi/EGl5I51sLsA5uoQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3fd189c1-072f-4193-8f1c-663b68b9b06f/bf63007e0f0ba0b3d07f1af06c1dee6a/dotnet-sdk-6.0.133-linux-x64.tar.gz";
        hash = "sha512-e0/gCVvG0+pD/Dsy8vwszI/sg7DFD/dLnpoBntQHIfRsYNezrAiEGl+J0IAtjDR7FKRFAyoA89moZhVYucdHlA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b700d687-929e-4e81-be67-1f7f39cd01da/f9d75264cbf2786cae51edfd57c72208/dotnet-sdk-6.0.133-linux-musl-arm.tar.gz";
        hash = "sha512-xmabIp3sZGchla/XoY6qwwpROoanAAbqtXDtr4qWfoUpvtMQ9OkQdvxM7H8LULSya7Gp1hcJqvPqSH7dMuF2QA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f92a7e79-c792-48bb-8d07-4a6ee24b62d6/26bc7013753251407efd71eaf6ad8a3a/dotnet-sdk-6.0.133-linux-musl-arm64.tar.gz";
        hash = "sha512-Tkz5HhzprAV2OLKjI2N1KMiYZtqPiPbHD/yI1UtrcoF4GtF+Ys3wP19oRHrk7O5IsV+5fJCLyaVcOMdb8HXCTg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/31aa43a2-5537-4423-8994-564c25089f9e/872a4380086a5a174025e2835a2fe043/dotnet-sdk-6.0.133-linux-musl-x64.tar.gz";
        hash = "sha512-9Sur8vgIZ1NZN0aN925x7322UKWGEzMJoQtNigTKIFPN+OekJvb/NKPmc0N/c81RabGhw3a8CZNfyjSozyEjNw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fee562a1-baa6-4e8f-a3dd-2c49eae8a891/564d31d1daea39179782c413f99c6160/dotnet-sdk-6.0.133-osx-arm64.tar.gz";
        hash = "sha512-wBkxUhZs775gp8vbSvfi3zZcnmegzg/1zBqgakbU/9bMzaO/AmpHEW8C5MUodf3XBKo4CBfbw+q2U9MPT1/+IA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c8f09b91-04fe-4d0a-8d01-0556c53f2a5d/cbfe49b3182a2c4ebc7aecd22b6ac881/dotnet-sdk-6.0.133-osx-x64.tar.gz";
        hash = "sha512-4UJ4Ula3MavW972nmxQium65E19hUm1vaHvmcUYlNAPL7IXT7mb0nld+fylrMvlPpwXM8EgpKxwA+YHS70/VLg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
