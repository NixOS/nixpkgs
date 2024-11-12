{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v6.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "6.0.35"; hash = "sha256-BxvIeZIaBdC0wyDQqKW0E5axSRSrtQk3oEPsT287014="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-9q5paA6a9Z9XH939/LI3CY3WUMI3k+3r5ql5DCQIvR4="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "6.0.35"; hash = "sha256-IcpSbsSHgYBbNVvbcXfmRRM9bdx3pogLncO4RuXEab0="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-sbboITtBgkzX9wtGhtQbjVHVlP+tOjr0eBvuTPR5n+I="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-CgptZ0sWSK+sq1S6vaHPSeX2VZiWQ1qB94BngSE3eTg="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-3fYohmmqpwAaIbZSD8bCOrHpsj6HbbOebamH4JxNk/8="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "6.0.35"; hash = "sha256-VQHuYjJLLOhgV0Bc2qiuLjDBYj/ZdayFApxvsMaybfQ="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "6.0.35"; hash = "sha256-CEguy8PYd6Q/xgPVoUJiT9Kjvpk3ViyY9S0mKkZRtYc="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "6.0.35"; hash = "sha256-3vy31ixbl8nmjyWgquh47daDf8KYJK1GiKdgUobZ4OE="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "6.0.35"; hash = "sha256-HffLekYLq/WAmBJaK7JS+08P5MXbsZRSO7zQsP28KIg="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "6.0.35"; hash = "sha256-7SitZSktVg5PPAxl3zh9v09ls4u57jqKoV3YDZWgkRo="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "6.0.35"; hash = "sha256-b7swPOMAs3J++EXnwPP9BnG/5ti+qs3q+73gO33cIx0="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "6.0.35"; hash = "sha256-LjGQxsPj2WeXJEM/t89iw5mZg6uOFD0fkLil0lqKq50="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "6.0.35"; hash = "sha256-6Zc+12VfsFsFbfuh727PB1j7EDQeiuJYtSA7MUxUXj0="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "6.0.35"; hash = "sha256-XPnsu3T9dfuwupKbGDQK2LsrMsvVasZZlN1b7usP+kg="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "6.0.35"; hash = "sha256-7+ldzOhrKwoQymhLz9Nk6tO7Hd3VxLYYUuTLAttmWZ8="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "6.0.35"; hash = "sha256-SWxLLPrTpdw9EE0sZeS4GGcDzi7vGVvO19TeD/Zo+kA="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "6.0.35"; hash = "sha256-tpSLvTe0WX8+N4L6Ww9F35aobI2F06lGLwmtoVGPoMc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "6.0.35"; hash = "sha256-NDUtM1/wQYziwzGZEtizHqLfgsbqCDyXdqRziZgZ1xc="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "6.0.35"; hash = "sha256-eJDl6txbRr3/Bcm0jgLq5sa0RjCpKjx9gJtxRkwKFa0="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-c4OtjF4mwQ5oDg7aTIL3UXWlgjzScj7MAiOZkwvtUBs="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-NqFL81Xr7RMl7Mc/bdKI2TCHzq4QpG4kdd7sERPzOWc="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-WUnzXWrYltA+PDv5lOIoNA6d7c6Yk0x5bO4AqjkttFM="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-PR+IPCMNROJiZxu7ZYRpzeAhW5N+HC6jEC3N/VXwyyQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "6.0.35"; hash = "sha256-RoTet98wvZZiKsDu2ex7HPtxrEIvDXm571bTMHPd4zc="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "6.0.35"; hash = "sha256-jM/HzLumZvI939DrNb8LHnEr/in1Lws0j/FAfdXSzbk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "6.0.35"; hash = "sha256-yrtPCYD8skaWnfIoaUdQ1dns0YrypxDocskS2WGxF6g="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "6.0.35"; hash = "sha256-jPUhSrzqnH1GNi/c7dSnZSQhFNVGdmlAQkDLdXVWBBc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-pQd99gNiGGK41kib34QMP2JN2nkqrVrYJqX4qZoZSN0="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-86wblZsGVVwesDUfxhsCHXecS2NpwBLAEZUeUmaHnVg="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-JRXfIeOZL7DVzc2Tb0AuNo3PBKn//bqtUzkyoqWF8oA="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-A1E7kjTJKLAoZ4CyImcFGus7w+/H99/U1MUhQXJzIl8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "6.0.35"; hash = "sha256-VbV29mYgcewUk/aCnc28eUCH616+h3M7K+HTLs4rqeU="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "6.0.35"; hash = "sha256-2eUqoTcqTU3ebv53IV6yvN9EhkOqnyBRd2tz74HuSsE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "6.0.35"; hash = "sha256-maNzxJQ5oCd86VI4ROzl4RqOV1RNXn3qWjrAfBjr2Y0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "6.0.35"; hash = "sha256-Gf3e0EdBEgq8GcZttTHbKGupFlDyB80nhYpBN0X9Kro="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-FemQgMovKuiS9dS48aAsMH9rQbUJnTM+olHU2gXJiqI="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-bQHLUwuKtiBUc02l6nqw0UntRySCZZ5f80jqE9GRJ1k="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-y0ZMcO7UQHK/tsV7FWxcaWs4cHnQIwDyS5KF4/MUrB4="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-0Nf5dX053Yy3ErDt/GH0IdefsE4C5Iwxu+V3yBQGXac="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "6.0.35"; hash = "sha256-NK9bR7E+4z4v6G1WqG74Be431jTgQZZnVUKIL1YH1vA="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "6.0.35"; hash = "sha256-INxaOVFZsCkue1I+uBBbB6bVUinMSJwzoW1nREyC/TY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "6.0.35"; hash = "sha256-KG5o3HrmzzUcHn9MmaQsELqhW9pbf8v/BEl8XOy26bE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "6.0.35"; hash = "sha256-1gKuXzwtNC84PBNOSX76ZFUT87DHuOEJmKhmZg026tM="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-G9oP2+gqthzh1TzcPx9rhuA9rIdxm4aKpds2jLbz98g="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-fMyXnJKdHAcPQF3bG5It53BmwVICOBJZ9mZ5e8rhjIg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-rL3yEEknGnpA0/W8GWkoT62C2nm2P1IY5b0FlWqNVIQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-hBpRmWVYievxvE7Oq2LOsq6flZWAMqOGILa1T4dySL8="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "6.0.35"; hash = "sha256-FfDa/XMaER+fNf0ESjA+ZG1YsxbniiDf667N1I0i9EM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "6.0.35"; hash = "sha256-Yb5w1a3vVPTd9YRdmsmB/GmVIA2h5UUMex6eJILttyQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "6.0.35"; hash = "sha256-T9wE4xhZFDRBFdY+aJ5ljQedmq94ULjgUl80JgOOLls="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-GqDM1An86Cix3IeE0ptVz/GevTeodIap+OnC+UK1JCE="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-Z2v8eRQTqqI1JTZELbRyC5nXWtq6Iq4hw2Kq/kZesTQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-Y+0OeW13o2vT3ZRUlSQnVMzhQefZnB3bEpniCK/7NXs="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-hkiXK3LEUWpi1sPKfjISRyDN9whidIW/7TcYKsf5sX0="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "6.0.35"; hash = "sha256-QtmwSe9LB21xBOEIP37msHIbLV9g/cp5j5qI7UeVy8k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "6.0.35"; hash = "sha256-H+fKDq3g0i6dgvbpI2U/EcH0qW+oTr5mkh7S44AWaLo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "6.0.35"; hash = "sha256-lyFTNQNL5Gd/Yz/wIn5pp38lQh91mpfSSX4ofsyPaXE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-zP5FKatImRSjN+UKbPpmB+ILTrBrL+YnEt+DoI2x00c="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-s+E1b74zGUPjb2ON4Ecu0YyaBmh89R7FuLumBIWwrww="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-71iLcbj3hgrGalx1p3aP3gnukTbbIzGX0DHayfoqc14="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-myOR5s0P8oGaNvefX2RBOMKIoWKdTYyN/VVXzjOUkRs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "6.0.35"; hash = "sha256-vTMU6Vb6WXB9Nwf/naJAG1Lv2SfmAd2rTSEh9e+ITsM="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "6.0.35"; hash = "sha256-6mY2uBhvKCpEFJLYX9+f1mpYrWdN69i+14DPjO4U8eo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "6.0.35"; hash = "sha256-cBcfv7tnZa2xO5T5VOx3/7EvJ5u4/C4dFnV1Jj6VFPU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "6.0.35"; hash = "sha256-IGArFhlq3UzZY93lJ+WrB+zmuu/2o8lVwT7MJKpz6DE="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-L1rUVh+A+U0kgoPe5dtsPiigrAwHYkMaHeI5deU/VCw="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-cOGw/YSJucZXdEki9rDo7XAWibi/9xbC1dfE13g+dNw="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-oZujYDpYlBKGKd6W72VJklXnywJmTAJAUbgD90u7wC0="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-9OvPAvtnIEx/opAkBBmqMGcRfjfCP3WVgJSydZNT2Rw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "6.0.35"; hash = "sha256-uOoIWrQ6cAUFTtAaaI8VMzk43m+eA6jijUQUU7e/87I="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "6.0.35"; hash = "sha256-ljEkMgkgfEeqzRnmTubjSK2dzkph0cSQ7+2J986F7HI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "6.0.35"; hash = "sha256-05wMp5+etiV/vgktqGo8+4XB7FNYxwCUKpJsW48tgvQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "6.0.35"; hash = "sha256-EtFBg8yBNhAEQlL97oVGiu05rPMSKLd0wE44zTBT7FI="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-v9FM/PSYQ0a6Mhp/xU0kTzqz6G1JEvFDgcvcOgoMg4c="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-UalwiTf1Wqbxi8duMS1L9S/P1xFAD4qkd1YnJjkWWMA="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-TKywsrAlBP3OIY6rieeO4wGuGvKIoeNx+rhRz3Qn+tw="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-nBjl1AgKzjNgAy9ebqwuMW++3agzj21DQRGOE6i4s6w="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "6.0.35"; hash = "sha256-Cal1R6Vv7iuN45fuIOx85LlRk0tdB0YmhVtoKmkmWCQ="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "6.0.35"; hash = "sha256-cDfyVD5ium1TUmjAEwmSIPZVOodXsE76lSi5l6fRiZI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "6.0.35"; hash = "sha256-/bEn2roiWJVqTJvBFIAdNDLVHaP6HVWRkJYFKQ1BwnQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "6.0.35"; hash = "sha256-yzO+2ZY1c2Qa5zYlGWcPw62lorqvmC9w3kqMemuDdIs="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-HBi4LxSX6yEC/L8b2SIOXxNLeUAJz2XJ8m0gSvg8JEs="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-P0bPG2kQtwoaSZRrWvWbHvVtKQ0bbaYBIL6y6R4AzCw="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-8KpLHzAuQtxX9ZvAah9tIZffgr3UdA1ioVjQhTGGoF8="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-4gcr5XiY62fdxU1PgF8URrhmRF38IwqTnCb4w211me8="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "6.0.35"; hash = "sha256-CbAFtObNlLAFckuxQ098QyRydKFer3Lx5GFqI384IHY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "6.0.35"; hash = "sha256-K48UCK5GmLu8XcwnhcnU/vGRp3Myg99zA1qjLmYf++0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "6.0.35"; hash = "sha256-TF0WcItnVgxmveY+HuQuPkJcTN0Ow2ek2vLNrYnM1wI="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-zQTo+xPX8ybQNELE+urZr4gpkk7DVmWioAh95yrTMaQ="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-9gM7UTQezIFzY12Q2hCnHfTyyP08LokuEpQM92axC3Q="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-4MuvhqMTP7CjUU5t5FuR31tDr36XGe4vO1Qa9T6OCb0="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-Xx5O61O33NGDkh5+RYwBtHKuiWr40Y7T01dwCSAzd+M="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "6.0.35"; hash = "sha256-1Lj+5osDgRccxe8LD7cFnOQLSznv7QqspICltvG5Jag="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "6.0.35"; hash = "sha256-54J48BHMX4YBZYBlSh8servhI9IVHs1rsf5gJVr2SPg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "6.0.35"; hash = "sha256-ckJ2xR4qf8OQdk/KhCjVmV91lX8pj19qjlsJ+i5bkMI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "6.0.35"; hash = "sha256-yKl+zDJ8afJUSJbaoXvgEWDGsedDFR0xL7ov+ww8MXk="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "6.0.35"; hash = "sha256-8+ZO5pMigKiX5bVQSthNZGm+HV3MCiDOZZ/RvyFZ6hw="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "6.0.35"; hash = "sha256-LQ5JsLnwzLDBWi0vEBAFD3tsLTqxn8pB21nyxctBXDg="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "6.0.35"; hash = "sha256-CK5Ms6ByKq57M0zbzRclrooBpNW4CHq5Pr8D1I8jvQY="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "6.0.35"; hash = "sha256-A3STk3RqaylVSY2mKRgcF+WHXXIKhobaOT/zNRo+wHs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "6.0.35"; hash = "sha256-Z3OPxtSzMp5QpQKPg7/PSPMSKbx1XNK3rOGvMulLCq4="; })
    ];
  };

in rec {
  release_6_0 = "6.0.35";

  aspnetcore_6_0 = buildAspNetCore {
    version = "6.0.35";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/44b0aa96-3ad1-4406-946f-680e9a52897b/8a6b84db7a63924f98b4197ce07313be/aspnetcore-runtime-6.0.35-linux-arm.tar.gz";
        hash = "sha512-LRUjAbm/xfnO2rxsmJAYdXXpDCNivscJ+73opCPab1M6z3ePNNVf4XSQbq7y3AnaVwtanSXdeopUy+TnP3RfQw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5b5b9407-22c3-4ea4-aefe-c958ea78e7d1/1abb142a2ff944d822d133af369dbe21/aspnetcore-runtime-6.0.35-linux-arm64.tar.gz";
        hash = "sha512-yUn9G57+kjHkxuAG7zxKWu3B1M5kypvBzVLxzpiE6iODe0nx5qerS23wxvYKMlc+Ku/eThTyBYEtAEt7nr4Pdg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ccdb3628-8f55-411b-b0f1-669d42604ad8/81283ab8762aaab1be72772711f07f86/aspnetcore-runtime-6.0.35-linux-x64.tar.gz";
        hash = "sha512-2G2pODOKbZclBDbUk0Do8RTAW0ZRLKViqtym8+d0A9NkaNPzTtXy2TXAcPnhSu33KZ9aA9KWTb1ldrmi0+d26A==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5d62f7bf-a359-4213-9801-a6e625abcd5f/3d21aef16435231e8dba45d9d97b66f4/aspnetcore-runtime-6.0.35-linux-musl-arm.tar.gz";
        hash = "sha512-Rbo8KaqV5IEKcQkHvZPafD46CceXLXsZhXqkeuT9X60ZvawsXgN/mr0ZlqJ9Djms/8Mnjy53gkdBQAcPNV2Iig==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fd8b54ab-b3da-4bbc-8cad-e15955a61813/f8afd41bb9cf46a39da72177b56b3a29/aspnetcore-runtime-6.0.35-linux-musl-arm64.tar.gz";
        hash = "sha512-TpkmOTjp3h+lCPzfClnn9hojT4vWCklH0EPFrFvDEI60YlS8txSMoKA5H16c7nTbHqYX9XbX43ryK6EI6UM+Gg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/69cd357d-c16c-4578-a109-8fbcdd5f0e30/9c6b46794e4c784fdec1990ffeffb021/aspnetcore-runtime-6.0.35-linux-musl-x64.tar.gz";
        hash = "sha512-UCEM7ZDRfqg3D7vK3j+/ub6SaQ+up31VFtyK3k7ug0CLLTf4EsygIAh0QdLzFGUHCGeSz/F/dBMwjrEvpKvWbQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ebda945e-7bb9-4079-b4f2-6a444bbc8d4c/1b7c0b929586db13610d8613329a9fba/aspnetcore-runtime-6.0.35-osx-arm64.tar.gz";
        hash = "sha512-VEhzIbRxDYIt1W31Bp1q/N0fmHZyd9yJ4bMDWrG61QKLRXk+m4+f9X4y1jMrW//ztobGUIbsR0OgJ2G0KVeTtA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/12e0840c-f541-4796-9b7d-7c4568f6af78/41fd0ea7532a0f0e26a6a8755103856e/aspnetcore-runtime-6.0.35-osx-x64.tar.gz";
        hash = "sha512-zIC6WajaQRI4noQs89svOqJjZUR1neTScPuwXHAOyR2gYrrTSYSYnFblwaecL/YMuDR+jmei8UqSqFm2pSVHxQ==";
      };
    };
  };

  runtime_6_0 = buildNetRuntime {
    version = "6.0.35";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c52af07-c968-4edd-acb7-766d81766809/9de0174ec8abfc27498b763c0e1bd370/dotnet-runtime-6.0.35-linux-arm.tar.gz";
        hash = "sha512-X0HAD45gzirQe+91o+rYmGuZtwaoxLsssPqMrfovq9rjwXUBqpx39jSq0CooyMiGkjWQe68LnXI9ZQITlSzpJA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f344652-6b7e-4136-b6ca-c1a46d998835/e00bad479ac747a8ddc90e7d006aaa52/dotnet-runtime-6.0.35-linux-arm64.tar.gz";
        hash = "sha512-lF4k+cLWd+Zf3aoGyv6NUY7lmc6YiDtg/Z1zQyD6Lz4cy/tG6ibukl4xn7VDDC4Y1kJp/a6WAwFpxLbT2BHqdw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/79e3d66e-14b8-4c20-9816-37c0c0964c8c/98ed84be388dfa1a7db279e9beefbee8/dotnet-runtime-6.0.35-linux-x64.tar.gz";
        hash = "sha512-2NENYA+2ZDNpSVdvjsBTTb/9Vz91S550HyCBIiH6/KxfUJp+GrROnmP8Mae128sZ5OwZMP/SkxIhLcdFSXcJDg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4355d376-a0b5-4b33-8a80-3171b45100bb/d8ee2b66411370f06b55daaaa8bbac4f/dotnet-runtime-6.0.35-linux-musl-arm.tar.gz";
        hash = "sha512-ya+XXOzd9F2FX8DnU1dkokso1kr0OmasJb/9a+lpmn5dsg9WrN7emeluRun2ITXlGvE25yJVnQx3++uH0m3qxg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b737d8bf-ec51-490b-a86d-fd6309965ed4/c2631e668020a1114fd5aa54adabb19f/dotnet-runtime-6.0.35-linux-musl-arm64.tar.gz";
        hash = "sha512-wBNlsOXMct/HvzwdUS7cdNDvlZy3phN9Z+ntnYom2HRCWOowBd8AmELLr0aETJE2JuPcuhWDARis2V4U08LmcA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30443c06-a028-4ccc-88b0-8a98691ec823/d0ee93efc931577aa00eabf7cfea98ad/dotnet-runtime-6.0.35-linux-musl-x64.tar.gz";
        hash = "sha512-sqP6JlbLJVI12IbadHU8eMPW1Sti4Q1pBTucCLZiZYZ9bzabSm4TOr/yHSspEnIudXQ44unbrRC522pVVFzUFQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/079437b4-612a-4a5e-be11-decf9fd90666/1932ebb2603542a3b647d958c9412824/dotnet-runtime-6.0.35-osx-arm64.tar.gz";
        hash = "sha512-SIDLPGlnRFKDHBMOAqShKCZTTWBbEVnEMu060E5hjg2gdgN0hMPDS9jHORwXMF63a2lXzaFGAK755yvUfaW9Zg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/55a4f552-2e06-4ecf-bb99-873cc072646f/0b2a5a90c60e8ceb862aa7f7160cf0e8/dotnet-runtime-6.0.35-osx-x64.tar.gz";
        hash = "sha512-czTb9uCb6tbvJwPd5p5qWo2b9D08otb8rzk/XE9K5arXyAPQxFR9AdbwgGD4Zm/PLB+9VDlXnVjZKHCGwNwfSg==";
      };
    };
  };

  sdk_6_0_4xx = buildNetSdk {
    version = "6.0.427";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7ba415c7-4750-44a2-9007-1bdcdee75c34/05c4467df0d7b5de0bc228a25e342ea4/dotnet-sdk-6.0.427-linux-arm.tar.gz";
        hash = "sha512-THZlTY0q6YxztN+GAC3wfFSaQRz3+hPxHoEVAbpH5e4EKC6sdab82s8686M/h/WrOowfLLTebSXgkTl5edDy6g==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/30d99992-ae6a-45b8-a8b3-560d2e587ea8/a35304fce1d8a6f5c76a2ccd8da9d431/dotnet-sdk-6.0.427-linux-arm64.tar.gz";
        hash = "sha512-kSmWG1Std9rCtN6XOHX3rNHo0oM2c6UZI3BmIODFt7jFsFfI05VTKtnaRrHctauP0HpPVSvVclbVoMIQcK1XcQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/12ee34e8-640c-400e-a6dc-4892b442df92/81d40fc98a5bbbfbafa4cc1ab86d6288/dotnet-sdk-6.0.427-linux-x64.tar.gz";
        hash = "sha512-qc0eXMw8XYR6yi7yHdFF9hxrGMTnWjwvya7VksYGbVEbi2WMVMLNhRk4/lq6I4bl9vUQBfZAa0IBEMDsQIqEAQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/58a54963-a8a8-44fc-bfc2-c2e87e066656/7d0a5a831d123b801c55bd6993c9e69b/dotnet-sdk-6.0.427-linux-musl-arm.tar.gz";
        hash = "sha512-QpfEiPsM33LE+zutBXQTwXOgcGa/ZR/IxAdbhsIjFhLmlJR7fsvsDUPNaSG4PfIGulKNOHo23dbGcLOK/ZOV2Q==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/49bb77df-ebaf-4a77-b6d7-d178c3b1f97f/c87e3f996af3fddd9cb253f0f5720d1c/dotnet-sdk-6.0.427-linux-musl-arm64.tar.gz";
        hash = "sha512-Zw6MlJQ5qm11NI0vphAYxmIdghzrX4Rz/5uBvBsh3Ck9Cxb6gETG5XKarcBJEmVNGuCkqEr03KCJFXExHp1M8A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8db04a7e-0da2-4064-b17a-c36888961d8a/3919a6cc424dc0dfd581569d02f1db54/dotnet-sdk-6.0.427-linux-musl-x64.tar.gz";
        hash = "sha512-OOY7wulLXfuqX/zDHpbqr5iJqGrgOyu6cu1zQ015hX1WVmNFxlogx6XmL0RLjxOj7Wo+flaKPDTIN8/OzRymjw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/9354e51e-f557-4d99-8b0c-53bb03055201/8267bd56eb17a930408805fc986e8b98/dotnet-sdk-6.0.427-osx-arm64.tar.gz";
        hash = "sha512-itcxThu4FvtBmIQpMSIOnsjIiFtDWW7IkK88IXeJQQE1Ov66tj8rhwFiMExqKiDRpFzu9Bn3LZBNWYouTo2c6Q==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fb30dfb9-b1d0-46a1-a59f-ae1037158de1/83d66d2d78b8ae231c3ded22f1832537/dotnet-sdk-6.0.427-osx-x64.tar.gz";
        hash = "sha512-HVZg3R7ObcaX5GeYGy9pxrM5q5PJdtSC76m0L2tcg/EsGS5bQg9zqajkb7vtk1+DZCF6pBC+3g8DKsmSstPqfA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0_1xx = buildNetSdk {
    version = "6.0.135";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/dfdf3287-c7bd-42be-9bbe-caeb66babde2/c611e2e9ea33fa8fd38f56fac2b185aa/dotnet-sdk-6.0.135-linux-arm.tar.gz";
        hash = "sha512-i5xwskkBYby1C9jOi/gis+ToVv62pVJXVSzBEaaBBb2HJkHBBIwTKAWEhJLoS8Ryc3zqZkcG/Mt5Duu//ASd3g==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/26d70255-74d7-4d66-81e2-529690046f82/701bfc25c386baea4bfcc727c9790b81/dotnet-sdk-6.0.135-linux-arm64.tar.gz";
        hash = "sha512-aTnKlKkdaGKn8+shVeRXIMmetEHBzR8qIt7YNRxf6gmBwu9DOwVzwe0uQzdWRmZqmvLI4KUawabDA92R4YdnYQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/69e35e96-d24c-45c9-a653-ea977a7e2a22/f31e9851ba9b2524740bf9d8b5a9af70/dotnet-sdk-6.0.135-linux-x64.tar.gz";
        hash = "sha512-+ZD6BjY4WjpOprDhzKpFYT/vRC02EAFSNvwkdIlfLCRGVZ8vuULJARcbuEfNgl/MV1+4LRIMxdHPF11cCuAc/w==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1bec17df-b72b-4c12-a2b6-c994a956fa68/11909df0d405b09250451b8392eaa953/dotnet-sdk-6.0.135-linux-musl-arm.tar.gz";
        hash = "sha512-efG9eL5bl3eyr9+J+SVy0ykVja4A+qVPTnquRxZBzOkNQx8DmpNQ2iWPz+MhjF62ovJnbzl25RqLp0KBy5q44A==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/350dc511-d24e-4435-a503-97cb85bc2e10/9adae96f67f61a23a47a73165a55117a/dotnet-sdk-6.0.135-linux-musl-arm64.tar.gz";
        hash = "sha512-3Jw7lZ/WZCT7nDdVf/ZdsH7dXsgWvNBSTNYPioeQJa4bQOy3dXkto3etz8IjDl0g9y5olGQU8xi7M5AdXmKJaQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/97d9a05f-760a-43a3-84c2-d401617a76b7/17811377c44145af03fab8023b8b1661/dotnet-sdk-6.0.135-linux-musl-x64.tar.gz";
        hash = "sha512-5g8kSywm1Aurm3r05RBcQtM3928dMzcQk9ssfsARi6Zl2VoJzZSl3jJPIspEWAayD+ELMGhEBjhzI60PoiKgVw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/82ff3f30-674d-4b21-94c1-9dc86a365a35/49c84376a1478ce39a77447e1b0925fe/dotnet-sdk-6.0.135-osx-arm64.tar.gz";
        hash = "sha512-R2bOlU/MCbDAThs+GeVZ3JzdwFU8gPKhanf7UGoqthAEDu05DJFT8+6nYnG7W6/NaWyhvHry7JzZIE9G72acTQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/22a4f335-6027-4d0e-a3bf-8ae061a5c958/8c710aceee7279ed15e5acdcaff49589/dotnet-sdk-6.0.135-osx-x64.tar.gz";
        hash = "sha512-jyLm2pDs2qiwXu5EP+YIn+iWgto6xOjT7i7iyf5gorXxZap0TKEqCnG3HsoSXVPa/GSL6C0a7ErjOhRDzpZj+g==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk_6_0 = sdk_6_0_4xx;
}
