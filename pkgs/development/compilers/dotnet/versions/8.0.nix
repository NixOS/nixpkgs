{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.11"; hash = "sha256-dXJ1h1xyeI+lzdoNiYtmLBzkQnHKZcWSksjuo70yp5k="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-hGOhBFXa0S+ks7hK61TRy/QxCCFMKvBjg5PLqmQtW00="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.11"; hash = "sha256-lo6MAnvFQ1DBDh+9qdxzOJMgACsvFjj2e5bhreJ4v0I="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-oCO+EBNhMT1dLFhRD+Fu7NVgvILg54DysmKaBF11A4I="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-WzGJU2YnwtGCixN0nu5uPuklqTqCCMw+Qx9/9/EOcpE="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-BxBnqO6dfWuuOnQFaoaa6CAH5e9GkJwx5g9RXGJZTjo="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-sWXbSev2UqM/FtLWRiuS1N4/KPUVOK84xWID1DWLH2A="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.11"; hash = "sha256-szAnroFmCOKpUsq8JuwZvFujB63Tw1gp1AjvKzhWa3A="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.11"; hash = "sha256-+HBP0U09vCT/MymfvoTBNQxvwaQf+idx8Led1wOQwdU="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.11"; hash = "sha256-IKUknQlc6h7jY/fubMEUrKoD0iUCwVbWqM8c4Bbcsfc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-it6NYhL3LSuJU1OVZGVZlfcCT1Qp+6F7HqWm+c2H59c="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.11"; hash = "sha256-vam7EuDSVFoHuy+FFbU8Ymh3sQLG9wMdiSaxj2T4Cmo="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-ax06WRRKM5HoaHHloF3cUtWV1lNzevboutJPiC5J/fU="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.11"; hash = "sha256-NjKhCO17oUdOJCT+xLpM5B+8WRS7HjIL1ALDYC8GcuM="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.11"; hash = "sha256-j5FiJkkV3AABI1OR0fmvMuW8hv88Zwdt7i83fIpGtaQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-sXw+BVbuuKMJ9DMzmwfn3b8Fq+Xo+B9ems/qoA1/JbA="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.11"; hash = "sha256-n/66rjJv9GEbsk8WqfvMF399gpxPw1DwimcvvZgJjAQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-Yb5Z7u0LRQ8yL0J+FnGv1zK+ZX2eyLhzh8KaKKRoC4k="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.11"; hash = "sha256-/eR1Vy0EfVgogp7cakiYfnVfNV9lNFlxe1yg1zaVvoc="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-6vnDnIgG7WSBKwNMocnE8NGJGB62ZnpNG0BWwsFADPM="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.11"; hash = "sha256-Ia0wZ130Mo1okAY8VCmKzEmoFuxf/OsBWVU1zpFJaOE="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-mqTJZAdN1LAgPLh0ylY5EkbhdML3GNab6NKJc1P0A/4="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "8.0.11"; hash = "sha256-vQBRn6AQ6DGpAwGxSR8toNOfzU3v41j0oIPN6fkepSQ="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-LCsjllD8Dreb54RPR81alvMB+qybF5ZNwMK6ngidr6Q="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "8.0.11"; hash = "sha256-8BsxXqs/yiJ7JjRP3P0sIgovR7sklwdUyJbxJ54Mo14="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.11"; hash = "sha256-rDS+IEBH2AOMInqtVYEQvl3e9Ur/16DARZ/BombUAdk="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "8.0.11"; hash = "sha256-9OGdacQFwxcfX0AdhpzhgJ3GkCq/Pmg6+fmCQCi/9lI="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.11"; hash = "sha256-4dVlrbyKBNht7cYDmxfkU0TPd87dh18AbC3aKVOpO7c="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.11"; hash = "sha256-/tfaYT4osjNoANDD9nYnT6nlTTll+38esUhA2iVIplE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.11"; hash = "sha256-vknkZgS/mhWs5+iBYPxhhZtXpdeePQYk1cfkDphUv20="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-neaDYzhgAYd9h9lMqoalKCN6rTWCgtvxHllhSFtfScg="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-3pK3sY8lzd/RsXl5pRNI6E4fI2pANjjlj7vGDClEKz0="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-XC1xTlNgV+T53G7ebuZ2NoMibwXG7LPBc6ZeSc8b+jI="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-9+spy9odn2Dau/6lIYMAkUhq73vzDlhG6f1De64CspQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.11"; hash = "sha256-G2/y0kdVL4Qvb0ONcGuQEEwX7QRwdEd85BuMJVCrbKE="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.11"; hash = "sha256-Nn9i9gSqdjsSpbuS2U562nUB/nCsMjoGuagoHGTgLks="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.11"; hash = "sha256-x8LMZdbVwjhsXwUbjsQKT61Qd7Y1EopoEGDeKRXKipk="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.11"; hash = "sha256-kwfUZm1hnsikJdpgTNDObdNL54wPO80TYtdNNlzfh54="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-pohSndeFtmmwQYG+O5TkAXCqfSGzxZXd3o2BzTez+Oc="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-gv3FHU63yPbd6+9fDBaBRL/RCD7wqDPaiG7OgcRBtJo="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-yZZQvr5Yf0NvsPKwfAxmGtOZkCq06W/E0NGJ3Nkh2Vs="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-kZunxq/qyNuRabAxI4W4r46cSHBe0YihE0T4wHSO2b4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.11"; hash = "sha256-M8RRVK3DlxSI/LmykjA55FBsCZSBqOZe2C2MgUCy4XI="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.11"; hash = "sha256-qY1nMywwCPOXxBQwXLeYaNSvu7wiXIp1fWeY8ThA4QY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.11"; hash = "sha256-brt8CP11GH1hidrkYbAou8mMQ6kr2eStr/oqesK6AnY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.11"; hash = "sha256-V55LsR6DmpxARdnZvqoYakebdJ+2cZykTMDThrmQnA0="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-5yhLMD3AI9N68nOS6wpuQmay15rLLcIeW61YzS2PmUc="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-R2NwnW05J/60vItgh1kWUAydh7lGEOpmUqxiOM/cu8M="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-u3/wM0F4PzcOgdOsUt60AbK3LrLJjHyHXn78WsApL6A="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-v2yQltoyC7Jk6q/cJh27pvclwxgQWcpU9nmT54rVmIs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.11"; hash = "sha256-V8p7NB40Xy7VGavZ/lLGRdkVil80gIhLhEBs6SlezBI="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.11"; hash = "sha256-Bmx3feASFv23mqZ4k4bCOkHw5V636+mB+NLYgz/MMIQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.11"; hash = "sha256-DSCxC8TwCQyALhNpvwZeX0Mw7EZtVGe45L/uUmuQsNs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.11"; hash = "sha256-x2PqK2na5cv5sFJoxr4Yx0AHaPFgI2EbzfreeJxohPQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-rs+13qo3NtCti5vrjsxWcbmL2qsxjGeINTTy2cAqzJg="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-xtBDWNuKc1EAPjtj20AT53q2bicq6DU+67W4nVNsa28="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-aQDxWrZBnIPqBAv6ZPnI8RycjNaWltfLjo47ZPBp5L0="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-OioGCB5S/zIZNSPjkD2FIr2nVGmyY0Ylgv/nMj0Aj0k="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.11"; hash = "sha256-MrQS+wc4JsVpshF6soLCOP15a9br4SUwy5jV49fETf4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.11"; hash = "sha256-UL6MbCykwzuKy4tw+9mrTnR4TyMJUXuuSuM+ZuMczE4="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.11"; hash = "sha256-GE1yHi2ScINMTZ8Rg/5noP+gnp9Yx+15khQ+Mk/XwIo="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-6HUSVK+vvmPHWBjWf9/PoV6VCBJKbgGbs2lqRRMbKAk="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-Yi+v0Q8cLe4t0CMosnFWmh+2BCFVblnejqfNkkUMLVU="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-YiFpFPWCsbYd0GbxpdXY8Rlwi7ArTnQvRtGgfqENHaY="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-ELk5NUG19HBO/5mLAGZwYZtjD/p1lS4/PI04GB2uP5Y="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.11"; hash = "sha256-tljhQ4zZa2cZqfWG0jLp/rycXPnH7tQW0C/gQoBnAzQ="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.11"; hash = "sha256-CayBWuwKxYqoVEi4N96fVg/44PZJ6GbcETYvxyGBnRE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.11"; hash = "sha256-Y5xrgKolgDwM1kO6ngndjn4vSs+5q3ZdFVfsUQdyCjo="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-1kjPKdr3dkK4jqQ40xdkrvlP/kRySgx+m7wo5NbxDis="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-QTH97dUVUo6whgLsKivSGI2SKf0xNyiQBjJpmjGGIh8="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-zw526n0gYUUazpmBtmC42G5GRL+dd4cvPzi3m1vFBiw="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-UEtF2KsyjjvQGRKvRcBctm40CcePwuhkxKdENgcj84M="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.11"; hash = "sha256-dCTJdICoFzocpUX8KHm6XTNeN8nUW1Bs5v7FSuRP3as="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.11"; hash = "sha256-DzJerzIbUYLmMl/EBOcpHcEzO9OuJ+fmbLJ90ADEKL8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.11"; hash = "sha256-o7AS58dmjN8MwwI1TTQ9H36cKjJ08MPfXXcCtblE2Cw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.11"; hash = "sha256-NxiVGeu54YKpQSKqVFVLSDD90ZDFykj/KBGYUCym6PM="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-qOxnbiarBq2eToQ3gsnd6XK7N+lTOJwP0eTst8AK9lI="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-9kBOGVS9zNho7+/l6Vn8/AS2ZY+Mm30X0ulgMsnxmbs="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-oo3SkDKYP7s+pqE+JuVLOyG/WustQsiKjaeuaK8eP8I="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-4CsczE4Oj4bsYf1UOvUu/Z/tIawT+21921CEeuxyLTU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.11"; hash = "sha256-CykvwEzw6XeWMDUS6Ir+uuWpC9slxUzqrrsqO16qkkE="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.11"; hash = "sha256-u74pARiTnPqmdxfxiRyhN3X1VEC95uAQGSAcvy3ReAs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.11"; hash = "sha256-O0U9c06Cdl6nEtmUFB3qoSMi2GcFEdVWLFwqED10APU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.11"; hash = "sha256-6HdptW7Wf1fZ8L3sUEpEvRtz5XCRSEcGAwpzVKtOy+o="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-PDK0wzOvlDzikyzo3fqpS76eCXtkBHKnz6zWTE7EfNM="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-jJPeoKYzhdGfMy2WNYgdpCfnEPSBAGC8SoRXpS0Z3/o="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-rYF4wiQfKBs/vi9nmd096pS/yGsWbP9rBOa0wZeWCkw="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-/pm8x4/Wqb6ks9+bCXaHf9qPCsK2qd0E+n+yQdnt7+U="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.11"; hash = "sha256-JgDBCRYyuacr6yc/tcjxHb2OMGeaqe/lyaGgG4+0714="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.11"; hash = "sha256-dJELaMJXmODYpitPpXic+OhTvO/RcTKu1gtizk/9ups="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.11"; hash = "sha256-BWqCOImHMWCUpAlNn8hN82BN+ZRkx8Ru3ZsC1QL8C/k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.11"; hash = "sha256-H99vHQU3BiSxX+qjH0BWQrD5RufguzfPHSMIFpjpU50="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-wqmM1U9c7eGbQ4/0AWMJ8OzLL4UTNLWJqgBH+V9nRg8="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-y9QWrbvnCeTDuhyMJV4Iiepeov5Z3vPaWLM82CRCjWo="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-Vw0CYCcToFtUs7XFuy8HHjzgKUoXRSK22MiVdHNaLfE="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-Bd6+7BbFT4jVudyVSx0oPAsqhdG+xQ6lS/V9icaG1bA="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.11"; hash = "sha256-D74oiqctESxpeOCl8mRGy7a9d7WeEAF+nPrGKe1oA+I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.11"; hash = "sha256-ITNfs5yyhw6BbPD76CBvi67aUqcDVmwckuh2wdm5vkU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.11"; hash = "sha256-t0+QCGqI1VbPU4haBWJG+znoWZ6Gx/U6b+xASECDsmU="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-RJm02saHko/bNY7qzEiCII+C0JrWPa2+/I2utswpHFk="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-BmTNSqqyknIsASeyrOSX7Vof3QWq8QCwlv5YNsIDdkw="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-A7KkpBj9f9Q1Db2g6IL4OnSxDuVqshufTm0yXdRDUXI="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-s2X7hfsO1Mwjh6lekNVm6l5UobvJRu/20DDxKz4yz50="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.11"; hash = "sha256-zsb1gpW03kVxjiV/QxkH2k9EypAPRdEk4vWGDIqh72g="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.11"; hash = "sha256-zdXSj6B6Ce/Lq3sNMf7eBInJ0qj/qQKg52RyalwZisI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.11"; hash = "sha256-1laLEXrcXI926EZpBM0mdO49pwUeY3vK6XMsjOW1cH8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.11"; hash = "sha256-iUz6q1mbsa9SbBry1AGAuKRVMCqWqC+/AIg7ddiv6cA="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.11"; hash = "sha256-jnquamFe/2INAuOu4eFbUsojlw3pcuFjhPFvqIND3fo="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.11"; hash = "sha256-U0JaTeN7rJ/Xdd5DkaxGXRFUdVCM4m8jWIS9KNi2sOs="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.11"; hash = "sha256-a5qXxypR1K9hIntAfAFOe5NdMlC6inrMfqiIiR0miaw="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.11"; hash = "sha256-i9HZMjwdHkshk4VV6VR4DEore/5RcTyNhWa2vhfBiuU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.11"; hash = "sha256-sbud6G3TDPaqjU3IbelfX/9h6VC0g014y4hcVxFT3as="; })
    ];
  };

in rec {
  release_8_0 = "8.0.11";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/003f180b-e695-4094-bc3f-ef6473883d43/e861cb56edd58b05b03b5a92cf995f12/aspnetcore-runtime-8.0.11-linux-arm.tar.gz";
        hash = "sha512-dmRfEpRlNGxd58VDvqU4KSKKmRKXHEWa5IJDMXxz9H3sI9e1LX2U/zxwG40t5lHzN13qs4EA+XvoH1d8O4zOHw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/64a9f696-b039-4a73-b705-288fbf9c2e8f/c36bc24d6d359c019408b4f94ee67b59/aspnetcore-runtime-8.0.11-linux-arm64.tar.gz";
        hash = "sha512-dbWIi31lz56XGSXkiWLAgi9jA5Cj8PBM4dhFRpkP7TEuiuhRPILK6toUXCrI3isin9Ha0tLfNsjp2w359lWVrA==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6f89757c-3dde-4c3a-96a0-b04b1bde2c92/6a3591b360ed0f9d1118b97560b89625/aspnetcore-runtime-8.0.11-linux-x64.tar.gz";
        hash = "sha512-56z53Fz6Sap+ww27lYa8e+qsnjEWx1MDtRF3DjWXsglznyjHVLIQfAJVrKyQGHzRAAwe53JGP8gok0pN2jX1ww==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/915433cc-c272-42c4-8599-e4dad1f37169/fb50da250331d885f108ef5147a55383/aspnetcore-runtime-8.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-B0gkLqy8R5U2lOGWVUy6FNkfww15f+afkEUEpwUigEXsRssN4ZVFIIzK10JoLUNZIfslMsI7W76CKV/uCAT7qQ==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/52d8da68-2c23-462b-8714-947d9c92f4c1/e57551e568e148dc30c3301382a0076f/aspnetcore-runtime-8.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-hiynzzSelFQgOhOJq4UoPJGhBNfWtwrmbDm31BOjUd8gde26UgZzFTEQueutFYAbayKE2vsiva+TVVuWQ2ffQA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c532eff-49e5-4177-9d37-54e1eabc1a6c/7cd1d4612b9bd15ccb555bc2a3ada721/aspnetcore-runtime-8.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-kSDvDKwgAv7+5KuQD8AIX7VtyuWFZ8+Pj2HwT29WI9yZXPuo9twsYfpNlt2jou4O3IUwtA/bwW0mrvW6MnIcTQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/67a3d635-a541-43c4-88ce-6f7882908693/5701a1609eb7231e65fc4e415cd9f2b8/aspnetcore-runtime-8.0.11-osx-arm64.tar.gz";
        hash = "sha512-ay0+tY13i2P5gqDVdTlzhqbQf8pknxuU3fCPxE6YhN9UdCqguChUzVlBIJhKOcYsecFUYviYTNwEGIVC3LYSwQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2e82f0c0-2d31-4fdf-b289-ae4157be0304/c82a8ccd41f2aa7918c7f888df1a40e5/aspnetcore-runtime-8.0.11-osx-x64.tar.gz";
        hash = "sha512-k+TxKd3fsVPyQYN1kmbQ0kohMefycjYbwF57G1UHHBxqLgN196ogQicSyFySJgfo4jRC65JB7nNgjS8gFcfcVA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b4d8f2f3-a0fd-4d48-b584-cae2c3af5c06/97479f98b5746e515d7d99f72b67c852/dotnet-runtime-8.0.11-linux-arm.tar.gz";
        hash = "sha512-J5uTv2tcXC9FQntiDFa/8OIuyPP7mk83SeemoNDQ7oFjhRtb0IHGgUt1gGjfe6G5QByES6WQWyeoMAIIRu9kBg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/501c5677-1a80-4232-9223-2c1ad336a304/867b5afc628837835a409cf4f465211d/dotnet-runtime-8.0.11-linux-arm64.tar.gz";
        hash = "sha512-8n1m3N0kmmovhyQbRgI4lgJA0WP/wIHY57Qr1icCB58aZ4TjUD29Tqj56BbYIUL8gpx1nL+aFoKwNA8M6+FttQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/805cdca8-ac43-4d76-8ce8-efd11f1997f2/17aeb8b0cd34c6f8d80217bf6a4ed3cd/dotnet-runtime-8.0.11-linux-x64.tar.gz";
        hash = "sha512-cepSiQDG/HtU6VFiIpZCHSqWGRhwxH6TcRe4Syj5G/QH0CBG3f7P5Kw33GGCxl0ZQJJ8M+Rfo9bwF5+BaSSQ1g==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a7c1c05c-3295-4564-92d2-896f35807f4c/2eda12f650084627e0430a52477a98b9/dotnet-runtime-8.0.11-linux-musl-arm.tar.gz";
        hash = "sha512-4p7HxMEj3r+xwgqknszby2xJOgvKjUgMET0OQTsrVG7QF2exBW3aSw9YApwUf1E8OvlWadKcsrq9vaTTWLLQ/Q==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/103ae393-f13f-4467-a050-cb437a0fc95d/49e6ee2de95017554e161b7048746a29/dotnet-runtime-8.0.11-linux-musl-arm64.tar.gz";
        hash = "sha512-apTOiI6wYPY6DslVSYUZjEjFxWEld9t8ECBLWLLvNu+WpZcGfXVXSr3KYah0cpFLXfMxK+dHc6wy+nBD1gNw2A==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/38650024-417b-4fe4-b0b3-aff0ad98dee2/a48665c0f7099dd0672e6c277f5e5064/dotnet-runtime-8.0.11-linux-musl-x64.tar.gz";
        hash = "sha512-/wDRnO1+ogTKzMbBHEhOWh7Nuf+prJprjtL398kImq0JjltB0uvlwky7wJVt9kAyti7XJ3+sPTtkt0LFAgm+YQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e5b4d32a-09a7-4028-accb-3b6c51828282/e4ecc94db4507f16a9916dc3be9b6706/dotnet-runtime-8.0.11-osx-arm64.tar.gz";
        hash = "sha512-LhXZOqWVFvLnefDC88e1Dv48RUfVRr/70dryP6ZQPWk2SbKpNV4DiLcIni3gcue4hKsEs4rWZUSuXJfC8gidHA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f32ae8ed-e8e3-4d1b-8425-852696e4dbe6/1f67d82ebd50b27574ccc4a06b2500b8/dotnet-runtime-8.0.11-osx-x64.tar.gz";
        hash = "sha512-wtAIyscrGZnqka1UDARAKqjCxVuZKoUHadOczq61Y09vfwTR27ylG92eEvBF/uMVtla1hTC1etL2FIDsrcyj0w==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.404";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/44135b0f-e6d4-4e48-831b-fcd32c06a17f/b5dd8932aac6655a1ebd99ea9f24cc76/dotnet-sdk-8.0.404-linux-arm.tar.gz";
        hash = "sha512-SJ1h47AuSe9vNBb/4mdeByrn2cP8Q/rAidNz5CvFeAeTfS1qdxfaoh8iWxFE9yDw0V9jJGDfsU0K0q24CI3k0Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5ac82fcb-c260-4c46-b62f-8cde2ddfc625/feb12fc704a476ea2227c57c81d18cdf/dotnet-sdk-8.0.404-linux-arm64.tar.gz";
        hash = "sha512-0UfKLmqti8dRtSKukTmeDjhnxC0X+JLiPI3QhqtsywwTMZ2bicAktaYf+ymOlbz8gtklYHTdrOiCFFydWkvgcQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4e3b04aa-c015-4e06-a42e-05f9f3c54ed2/74d1bb68e330eea13ecfc47f7cf9aeb7/dotnet-sdk-8.0.404-linux-x64.tar.gz";
        hash = "sha512-LxZvfzvVCBVNctF4P/rG4OPJICPMwsbeSdIrQR/IuebdA+dXaswbtYcKaVEYESm6d/O/lLtF/pxwEFsbiWubuQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f5680df-0666-4ec6-a3ca-3ab9897b493a/178bd00a6a8f7ff3e10ffb4e01490e7b/dotnet-sdk-8.0.404-linux-musl-arm.tar.gz";
        hash = "sha512-syuih+oQdbz8S1TPYCffsaV2cbttri+NfUWrWwINQqyIZcU6v2gn3ukQ3LOkHbq/dSjNxoGxp1psTJ/cXcs3CA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e39138a8-4431-4cff-a00f-482c28df9639/9d5c2633624007715fa7312f42155272/dotnet-sdk-8.0.404-linux-musl-arm64.tar.gz";
        hash = "sha512-LCy68XYHU51nZHtHJL1uEfHQD2F8mMRAjslHwfKq5HTdO7AV0Lw5IS7u/p/NvyDmrpVwCKrpDHIL7sDrx3mM6Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a42bdfda-e5d6-40ac-93c0-b6899fd39324/59e918476a837f928a5ec3f21efc438f/dotnet-sdk-8.0.404-linux-musl-x64.tar.gz";
        hash = "sha512-5to7QF2GLzHXkPUZcW8IJ6BY41gK/gnREDUivkLlbC4r4egAuU26lAM0WFt4Xqtho4vtAjI2lcpEBwh+bAy59g==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e8f412c0-1701-4096-9aa7-48d65d11ae67/cec57d5bd873f28b6f33da25915cce9c/dotnet-sdk-8.0.404-osx-arm64.tar.gz";
        hash = "sha512-ZHZTGmO/S8x73eL1own6Kykgu2MOCPoKrqvWV4u4HVNLHdO60hRhf3K1VVpJpWuex3BibWQSLacHbfwT8MVsvA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/016c2c95-c728-46ce-b227-d5dcc1c29f43/b4d6d9662623bfef39abf79711793f32/dotnet-sdk-8.0.404-osx-x64.tar.gz";
        hash = "sha512-ImkSnoHWbNDLteGvEYXLWsEyTOia60Ft22ykbGVZzCyiI4ZLyn+IzMa6NPcsl/9H+nzxoXpZCMr8TXx3JUEumQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.307";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2ea74cf-71db-4938-8e67-0a5ba0e8dde2/77b8bcb3f156cba40b28a6bcda7259d7/dotnet-sdk-8.0.307-linux-arm.tar.gz";
        hash = "sha512-kpgb3Nz9GE215AEgLjfWqoQ4O1I2dADib7JcCLdd6LarCW5XXXMESn1SMMXUeAAavOTa8ooa+zcqwjRlJTgOTg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/78966954-6f88-4240-a857-e88592469928/fa48764c7075b3eae626e5df5b27bcb9/dotnet-sdk-8.0.307-linux-arm64.tar.gz";
        hash = "sha512-XTuZK1JfPvi+X69nN410VyEOuBRSxqQJDcxgVnR3l4SAvhgNBIhhZaSjNFRkIbrFxFoNjW75tA0Md80tXm/N5w==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/645e379a-4222-48c0-b47d-f85719ff91db/2d46079600e454c634eaeca43a54ab31/dotnet-sdk-8.0.307-linux-x64.tar.gz";
        hash = "sha512-lJI6XMIze1Mb073wjJnnFp7NTIGmOiuM4gT7CHxOtSZpUhj8djhg6ikwQmwrMcIyjfEzcNZCF9N1GYuT/fBMnQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4cb9611e-2d70-4721-b76f-7e4af40c1ae8/75a00daccd28df34a5cf7f21287c2c29/dotnet-sdk-8.0.307-linux-musl-arm.tar.gz";
        hash = "sha512-wzz7No1d/2TfqtVIL+21mTUJxkxlnwj59Iq2Vbt2kx7Re88PIFOkYogg5ciC/T+Hbj7wElxoNiXG8op2B+Y7+g==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2cf301af-8fb8-4bf8-a79c-0fd1ad5ba601/b336f2e5a7091c9dbffdf69833ccde58/dotnet-sdk-8.0.307-linux-musl-arm64.tar.gz";
        hash = "sha512-UBos77oTBD8K4dlgm8MpLaIXlA9THi9nJ3wHON52aSJS14E9y6cG7cKiD0ap/naVDHwYAyRm6Oj7SCTnrW/v9Q==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ef349e2c-79f8-4688-a79a-3236e75b2868/fef58217ba703f880cb5ad02e22976b4/dotnet-sdk-8.0.307-linux-musl-x64.tar.gz";
        hash = "sha512-JSVzy31AEopBORQUjDl0wQW6fIueAye0piW3o+MVQXe+vb/UicJJP7FPq8CXwWGrT8mKTyanNKX9DJkj9bPLgA==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6a89189f-3449-4e54-ac20-d07af68b772e/ce34a179d9bb8bb0cb01781afd662bf7/dotnet-sdk-8.0.307-osx-arm64.tar.gz";
        hash = "sha512-xSLZ4iMh0ES7tEfvJIabEldT0iZ6XdU4cFm+CZ031+mBs4EDxN5pUhAnSyxAom7b+GWMg4wm0gtE8x9SG0W11Q==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7dbf9674-4262-4b44-bd3e-12a962f2831a/b25b3c126ad41eda494855168f8104fe/dotnet-sdk-8.0.307-osx-x64.tar.gz";
        hash = "sha512-yT1+pQXD1+GrAko7ARDr3WgyxYK24/gHkLzBVVTgOfqq9WyaK2R7vNJcEm7tJIcXCLuWQLR5BFLO2Z3Rca0V1Q==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.111";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0aca42a5-6e85-43e4-8fed-0a5af898c82d/0ee32409bad9aec0608e1bcf2f767a32/dotnet-sdk-8.0.111-linux-arm.tar.gz";
        hash = "sha512-Lw32CwWHjgLBaFXElC6PR/CaNWxZi1WEbKO4bppaSQDndP11rWmADaKZDRbm1PFu3MU+X9m7BpmOtKvg2p0shg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c6a51c8e-3dbe-4f8b-a642-6e4be0ea0171/e98afd2817656cd96445fed528776661/dotnet-sdk-8.0.111-linux-arm64.tar.gz";
        hash = "sha512-mtGoNJ1MtlL76Z6ytWsscU8Ju0nswjGNhZch7b0MLB5fM4RE6h7m3S8C59EBvODTyVaRMxJncDcFlkR3lJilTw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/71b9adff-5d7d-4567-aba4-d0da010e293f/88bd38320ab4a4524e71aec64bf88676/dotnet-sdk-8.0.111-linux-x64.tar.gz";
        hash = "sha512-5G45p3Gyl0Tc5mWofNUyLfqRKrKQS8wQ8FB9/PTKBWhM9kw04SxwhK9Jp4TMBOtTKjrSvkzrZoF2NH/rS+N/gQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/23273a60-23a0-4fbd-8ffb-8eddb2880ee2/65a67bebc6cc7d85fde858fb501e5c4d/dotnet-sdk-8.0.111-linux-musl-arm.tar.gz";
        hash = "sha512-KX+iiMjBdOwWrp13VBFmioJ70iJ3cisPKIXuYJfAqCfZ81w0BSzlipDxbU/uyr5zjGPxyQKzqP6jZ3GjveSvvg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/60fc0fcc-1f82-497f-8ed2-89b75ef19388/d78cb2271cfa396e119dacb534a0e8bb/dotnet-sdk-8.0.111-linux-musl-arm64.tar.gz";
        hash = "sha512-fNb6Mz/BleX1UVu2dbhuwxYKTRqCxolrOdBHebsdKqhndJjqcqfT6Fq8CGRlUtNhonfZpvuMQYr3B335TyrgOg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6b36b2f4-0a10-40a8-96b6-b222860f9820/22605ad401868ae796ec1911984c46a5/dotnet-sdk-8.0.111-linux-musl-x64.tar.gz";
        hash = "sha512-pRdTdDsBRQYPfbF8M6RwjaBfH/ftoEOunzmjx0xadVN9AW6M1rGBisLQPtANNTm0oc/0s2BySgmCK6qKiW+SAg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/92958c4d-e15c-4554-9ab7-b6b251fa95e0/d931778a5156b6d739583cd1af0139d8/dotnet-sdk-8.0.111-osx-arm64.tar.gz";
        hash = "sha512-tH//G/XZ4rXKe2hNcqBQTDzPizN0uNei445Bci9+EXSAAfzTRI5iYBS5/KeAgr/tnA5G9asUGmRkIevCGRuaWw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2c694b43-e8e5-49b4-a26b-a8d1850d8974/aacd6da4f057a37d12074b076368eda6/dotnet-sdk-8.0.111-osx-x64.tar.gz";
        hash = "sha512-QZ8qZeVxRTexhWkcmnFSq9Tl+F9uWAZghuPzQepPFuD1ZL/cZM3B54djqMO4crds7CXL93/PZl19dIGcYf3Jag==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
