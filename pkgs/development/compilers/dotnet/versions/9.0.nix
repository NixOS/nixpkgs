{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v9.0 (go-live)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-dhl6zr9+TY8ty/bJjkm7bVbRwc6J+P8FqOiv1B3/+yc="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-5NMC2RF2xmdc5tPbeDvkMtr24JeWfh1LzqU8+3o9nz8="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-N3eNI7njwqYAwf6Y/MEliLinqCbR05lSelIWgFG/P1A="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-KlBEQYRSy00ZH+bFkG0xPpwT7qOmm47bBgeblYtI5G4="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-FJ+4ZPyU6LZLGr0c/zffRGH2lpNrclbaC3V8a8u9kro="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Ye6nUVh6gkD68zVlUg5uXYob2WCfNb+NgI7ByGkPrsY="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-PnyYvI8pAmh1P9VWXX/Ckz4THQEbiwg/3wD7unDy/5E="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-leqqHeRkRMJCDX6P4mzjdc/E7X1GfvdN2iZ3QRAOjCA="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-tmEH/rvjBsmocEFt4iFnzILq+kJqEO9E6GHXqFTLmE4="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-v5lk9Y0Krg3P6umdHnB+3RORoovXRzUkKjmd0WWLtB8="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Yv0eYUjFuGPEl+NNGboMQEsuuh72pg5adUHWA0lg+9w="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-x1VIdkrzpg3GTVtHRlKPsPC062H3FZyu4ZZsaitTjLw="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-f7gxJhKCgdqoByaOCQUCJRfkzvvQn+EbaZJqXJTTLCU="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-qjvgKFhLLRDYEJZqJzzosj+G0/2rHVo9iltR6w5YvOI="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-9odWsDB2OiwJ1Rw0SfNREnSvYn1p3WSmomBFbWegwOw="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-BVQtI6mHKz/uRk6jszpYesgKvnOmiTEQa5JwjFmhp4A="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-hioVbT84W4i7/Li0UIuebF34RHwkHRCdYyn7vxkMyk0="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-zqAivHOPdikSayzdg4lWEaB8yvbdRIbhwuYonx+cYoo="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-y+lKV0p7ybzXtDpTY2GwCdh2IWnAb6MdeQiRD87tr4Y="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-fhc4491T3JB+k4XmPyfMK6bwqpfx7Mbugs/sh9hCb6U="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-hF/f/muateSDsp9oNafpzgtFtNm0kYuAG5YhJCVx0L0="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-9AbfJQ6S6wxIwyecuMQPFp5g1Be/MZKz0A+YLvg0vME="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-gJIIbWDEcDP3fJZLS67+pSeIUBJPdAxy/ICLU8nKGLU="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-SdNqAE+cjhGk8Be1sPOy3SvcXmUlBEvFUAMnGaBm9dU="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-C/rbNcMEVFr+X4cc8uWafZZfTBmVrdohkwlVay49i5o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-CrY8BoFI0y3jGCoMUxGle+q/1eR0jDo3c4/OHGkfpWc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-ry7q5h8R7E5EYWekPpurKvQSzIvgk6+PDhXmO8LGmbc="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-rWX+2sujaeh4865lAXlazeEkAhdHv+nOw+nUGFg/PCY="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-X+/z6pjwjLfAaVlRu9a8UppQH+rWGNfOd+M6T6IpGA8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-AkQO8KH84aWw/nbLTU5Pwe3Y+nMY6qO/ocak626vfTI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-gX5B8VfFFKQ/c+ZyW/plJQvJR0tD3/L5u2LAF0GwqKg="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-/h8tt997pSkGTKFcPjc41m1L6aFtnlrhyI89qtT4AAo="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-hzjiFI6ldUwohHqn+joLwj0QCSEsKA7fpsusiSUYiOE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-c7USudhIPx+sIax6rAq35ZWENK7VcvTRMI5Zjw0lBRg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-rW+noSMYQ/9HGMWY4Q1GdLyJ4XlwPGyBoOxJaldKU3k="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-3PrM40rNOxEETs+BuB4apQp11UM/Tt4qCqqEe6pDCug="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-fbp4ArPk2XTAssAQTkrNtFHU9kzIV5zY/Jjq92Mpi+s="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-RWW2aK5C5b6opNsXqnO6XjCDPZ0EtHToHBOgPjGQS1g="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Wd+w/+tWFL+gmhmf0wj1ym/JURGxHjJqLsieHsDw5sg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-QELdzwfVBm1vMmFWdSN23g35/O/rtan708KHN1PiDV4="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-yvHXdiGpCUWxLduToPbio8fcw9Mtyl5zvo9tCg0aV98="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Zrs2qA7PtIYBjpk/i3HzMrqOvU00I9hBfTjp5o+4fsk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-fsmi+VG1+9QYegQT3vPN6QhNVUOKQu2X4u92etqPTfI="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Wr6Tsylj+lyhfrwMUJ44duIJ8qTNQzxkmAMy90hv1uM="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-Cn7eSPm1YLMdEXGkNwiFo9nGfHNq+bJRFA3f4A/9Aec="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-CGdQ7pTIO8gUrWB6KozR9DWrILLNk4K50p7hfj/KA/4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-PHMxmQJ8GxmSliTONInEGcKUxAfLAlmY4v8H86dxxYs="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-9Botmmfm2w8kmre5N6QdhczSl9ULvPKzNi8A5SNxP/I="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-FCTCJCtnbeN46+G6jionwMVL/ombLiWJ12w8gZv7vPk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-O2kh/ld/qx8AoltZBY5QScxXmePNwu25xwix6aLPhuQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Nek+eCGSSlSXFElKc3ZDdKAR+VqfYIKO0ZvXxLPAnvQ="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-GhT5AhdQZnFFr3LZsArYg9asONt+teRjUJJjenhSY3k="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-Goj+/hMmaBAMPB9E1whGTgDfu2a5Kd6uAnIrLI88juQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-dkt2vVIvPIt+ewrp8ggNODm6Bvbj6LLpFmHH81PnVSw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-mQflfj047ONkda7KpQZga0WWzbIGzMf9Ls+ipMrnpuw="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-LIOwkyYFeTVmiQjJLt++yutwY7rLupshKhptuciNjVI="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-6aXnFRj5cnGWFjL830CktLTqisZsqnSaeuBC5J39eeY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-V0WFhdRjor/oI4pcB7/XhKjBFefJFy6Mo4BZjmUJjEc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-btKg62ky/0St7WYjXXZnoz99DdHNUpCnOXHaBWSc/rs="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-LX5fCmJl4PFgHStU5s4cNjUIeXFlinlA0PAD4tRYZk8="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-gRLb6tj22ig30xwYcSGL+mb3IEAoPweMGJtbTpfTS5k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-WgEZAR4QO34XCQHhxbZ4DAlRDXkdyftbVFjanN7lm1o="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-W2K3711R50a4ofgvv9lOsHY8HC2luKjfSTPByGJhP1I="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-Zv+W3RVduqZy+8tDuGOzgYEDwsJf3rBTehoZKGC1eEw="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0-rc.2.24474.3"; hash = "sha256-R2ZhPNxNQxgvDMENdOblDL+PpZqfjzau70COkjUTO10="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-XgQyMZ2KEgZaBgrJKGYtlL6msnvxoLvzisHdOkN3Nlc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-1RpTJXq08lBJ1SqBNKSzZPs3DB6Wc1hNXYYuyqwI700="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0-rc.2.24473.5"; hash = "sha256-IMroqfAI4aHTFggLYwURdsY7Z8M3mly8QEJjQRSgPa8="; })
    ];
  };

in rec {
  release_9_0 = "9.0.0-rc.2";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-rc.2.24474.3";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bb68e2f8-fc3e-42ae-85f6-ba2bf4bc8ecb/524d5256a3798a7795837d7b104fb927/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-arm.tar.gz";
        hash = "sha512-1qqmHfZrxCKWNQ9WoT5PWltWdw5izfS7KmR/gNs7ymMuf4tk27LSuEJuhi7fPKdb68/p219qbpTsCFV6T3pGGw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/687495c2-a3a5-4cf5-98e3-2adfef55a1e4/ef59f43e13c7107ab17e59c276da2485/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-arm64.tar.gz";
        hash = "sha512-tt5mjOhxRHa+eK4A7WYCfzpbBtlcZ2itaz7KTQ85bJGEMmfA6MAxYLcJp6zcvCsJBH8eyNRjCdQMPTH4ScyYHw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f75b68ca-9e93-468c-925d-3ce85f8a4d0f/3a31e60149a0ca0f9e8d7c05666cfcba/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-x64.tar.gz";
        hash = "sha512-k3DCYXTNfxsv71jgpTBByUt9VBLxXqWGX7xlOmWxSLH5LnmS8UdhCmyi6SAR/yjENICrJqbn+M1W8hia8GEL6A==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bc4a32ff-51a4-44af-9f7e-fec219ed91b6/4ef16e8019a45a760fc00569cb979ccd/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-arm.tar.gz";
        hash = "sha512-+mwjYESxZ9+g44mq87jkLRQp8ZOvAUua5oV+LcG2SmWoAoxqwX6D2+Xsh25o7py4U9/gGciLOp+hX8xqoLAX+A==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8548303d-93c5-4846-87ad-af4c79877a26/6e3dc8573f2cd923959bdc39c8d37eb4/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-arm64.tar.gz";
        hash = "sha512-YwPe+FCO5N+Xnm7mgBB32n0FF9MgO9/3SjbNuuVwidfHJpHtoApdqnQLKDGQlQtcqO0PoRErfSqxHBRZCd6RmQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ee8ef896-6330-4f7f-86ad-172d67793e08/fdbe8aa1eb6fe38e8ad3fe471495d388/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-x64.tar.gz";
        hash = "sha512-nEGqO/ymPJSP+HPMNBoJEEmEEWfmRMwU8fVD/qO+dbEICMOEgwORb/NHIAOszYAfe8gfzIbZLBpcns0p2b3jug==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0ffcfb0e-3d17-4b00-8bf2-db75b095252c/5bd0a672caf63b32b39b92c0677a2a4f/aspnetcore-runtime-9.0.0-rc.2.24474.3-osx-arm64.tar.gz";
        hash = "sha512-HdXqCzgA3Ti9piOSgJM2A5ummzrD8agnOmhmTKDCO2MoSKNIuNnp4OdlObbl4VgkMguDBXHC+uPflK0PJiiNMA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7a757e46-1c68-449e-8b1c-64293c30242d/aa10955edc95ab4419bbad34f8e4899a/aspnetcore-runtime-9.0.0-rc.2.24474.3-osx-x64.tar.gz";
        hash = "sha512-tirwJSlndP0w9g6+OKgGEviqB4Av/PHJPT2pBStGEQj+XK7DVvlczYdy6nUUhiw3mvuzwZsjyOi1OvmhhAiBPg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-rc.2.24473.5";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a0fea09f-b78f-4381-be80-3bb7c363f010/7dbd31bdfde0fd28038f9feb5c24de4e/dotnet-runtime-9.0.0-rc.2.24473.5-linux-arm.tar.gz";
        hash = "sha512-w+oUlK7VbFV0BnhuFtriWi0bCeCG+kcL7nhQID88mV/wh4ujZwehFxnbHlF8b8ulOxA6aYe0/akVjfU2y/0n0A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/59fcedfa-70be-4166-ad7a-aa724c8d0754/56ab42fd18b3ec36eca8e9a52398032a/dotnet-runtime-9.0.0-rc.2.24473.5-linux-arm64.tar.gz";
        hash = "sha512-NVzbOrCgH74jtwZ5FsdRazFq2jYN6pt3Nf6TXsoXI8obMkB+yjr6fHIrvwYZkAGabVY7w1l/33KUDOs4rirQTg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/69beb740-ba0e-4a0b-a82a-737c61cb75cb/eff5e94b382efcdcd2a80278e04edb92/dotnet-runtime-9.0.0-rc.2.24473.5-linux-x64.tar.gz";
        hash = "sha512-ugQx57uCrMqxRM8WZsRwVJ2BAqF/JgzX4NmIkjon861cEMrdFgtaGA1bsVlyFD8w/bc7aH0fjMwC6ekzSrjCzQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1ae9bcc8-f0c6-4e58-ae9e-1a97ad4176e7/97a25ba8dd8535ed125d0c3773a8f64b/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-arm.tar.gz";
        hash = "sha512-WeLXyzWmOYR1LSlr8CoejCqNsNy7K7zkM3X59+qN7ZOGfOTCCwnAPelOPjNGPxXL+a/wWKkzHa8KxQTEdx25bA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f5868a65-9c13-4020-8f22-afbd6ce09d13/7a342e4798cebc6cba90a6569e9dbec0/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-arm64.tar.gz";
        hash = "sha512-PekyCYPo4EPrW8MB4yRCVXCyHM8NXrl8Ph/eKrl+mCBtjReE2W1pE74LtLjOUMXP+Vbn+Jge4KHxyd8idnkhKg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d9e2009e-5bab-4a62-88e1-ae5e3ed4e0a0/617b2bf0e8292164424e71c342ed8d13/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-x64.tar.gz";
        hash = "sha512-1AoYYdTlUKRtTpEEF20QfqoKG+lMxqxYPvMx5q0xzK9NN6QnYgMAo3N2yG8SKpIKK3tAtOSsNHvi1io43IPZZQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cb30091f-cc2e-489f-a8ae-87a08a9d220d/7ce11a740f6d5641c514fe68b2cb2dd2/dotnet-runtime-9.0.0-rc.2.24473.5-osx-arm64.tar.gz";
        hash = "sha512-e1DF3vwyGDOYKU5MuRpZBgYXZ4QIpYbOmB4PR/uDPIUxsw4D/EZXoJFjRgYFcwJB42bJITw4EHfmVHU441bosw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b9385375-2ccd-4e9f-9e4a-8d7f6d58c3d3/00e123163e6bfaae9119c5fb355f0d53/dotnet-runtime-9.0.0-rc.2.24473.5-osx-x64.tar.gz";
        hash = "sha512-TSYNygwim2QOkORVS1FhwLnZX4u5gOtT5hlAviLIMoSdMokQfhyBWMgYklh2GidpXppClrkIag1EyMEkQFMfyA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-rc.2.24474.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ba992713-4a38-4b45-9c24-8222f2ba01d7/e8746f2e70e0f06e3d9282c6d43bce65/dotnet-sdk-9.0.100-rc.2.24474.11-linux-arm.tar.gz";
        hash = "sha512-c2oOG/d5FSjmyYhIUX9s5x2U+hpacrHl2iybVycJ1Xlkq1OyDx4rn8aOLMc5zbo7kfwI2F6EB/u/zQ1fuxHH2Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/817f5589-0347-4254-b19a-67c30d9ce4f8/3dfe6b98927c4003fc004a1a32132a76/dotnet-sdk-9.0.100-rc.2.24474.11-linux-arm64.tar.gz";
        hash = "sha512-tTLcvLR8T9LJBgGNLsZj3hcZF598naj2Kj8hpi40zSYJ+3zuyJ9a7bKjUkf2f1Q6AsaE4WkgU7/y/cQYTfY/Uw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/202e929a-e985-4eab-a78a-d7159fc204e4/0c85219d441cd3bbffd4fb65b7e36fe5/dotnet-sdk-9.0.100-rc.2.24474.11-linux-x64.tar.gz";
        hash = "sha512-EmqSv6nvTnBgn4snzeD64bFEqRr4pG3pSdgD0qobrQKFsbm4/GDUAgbTRqrEnkhwm+xOds325Un4kFCGAD6AmA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ce9a6b41-d58d-4def-bf4d-2ff6a022c846/321706c736aaf0391a642d5d1e4d3e1b/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-arm.tar.gz";
        hash = "sha512-pzn40pdEFS0zt7O3SThvD1E7ZtHy42PBCCu4dt7TiOHMbdJrD5ArO835V07dOGn4ALkjZIw92pDckbdsStXNlw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/add40efa-8de0-4fb8-9ac1-bed94c85caae/30527cbdf0f429eb778ab03f2fadf896/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-arm64.tar.gz";
        hash = "sha512-KlWo4OMbUg3ZzfPvqA9Seuh77DuA26RLxhPKq0dWtz0fFFCGSJ+rD1WpZogCmsoUBhriWNHc/Dbt6O4LKo9Htw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5e1ed970-6da9-42aa-840c-784c63c3a1af/4bb5d67f6983d22667d4d198d6e72ffd/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-x64.tar.gz";
        hash = "sha512-JCyCo2HXOcuZdhnJggR7BfpGyNclZOq4TaSdK4Mb6xxcvyveWA3wtoVYdL8aQ2CiYxkSd9VgLc3GoBlDWgDO2A==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/90c92374-0f9d-457b-a612-13cef4db7507/fc5ff8876123abfcde954906215ed1d0/dotnet-sdk-9.0.100-rc.2.24474.11-osx-arm64.tar.gz";
        hash = "sha512-wkVoXBJXKVaXrqxs8WnNY3XX5yXruHYO/OvsOfpuv2/jrVtgmUJviZ+KCgMywEeXfef4QypObyijSEiRSpJboQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/33f4f5cb-7423-4930-8e4b-d96f1fd088a9/87d414df2c160713cdaeec06c62cf6a9/dotnet-sdk-9.0.100-rc.2.24474.11-osx-x64.tar.gz";
        hash = "sha512-EY+pVt0zDQ30SeFGhbNi4ut7RPvpVBuXwSXZOnjcLlMCiKO6Hro5KNMF9KC5JUyEgMC4kwQYciZnn5W9bxvHWg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
