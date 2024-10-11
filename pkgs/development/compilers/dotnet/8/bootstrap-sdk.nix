{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "8.0.7"; hash = "sha256-4jkbKvnRim+1K1KMDzHzzjZk9ALU2lYJVY1Fzr8Cmqs="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-+gSph/v+GCUhUlyb9yBy7v+sWvZhcjn9PhAKP1xm0xc="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "8.0.7"; hash = "sha256-q35Ye0w5YqX12JOMXeAXp7ce4nvZQlv0K4GN6hSCz5g="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-Zhucf6Bi73PwwJZBYal8LFsbPe3aaWTf/g7f12su6pg="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-aKi/gbcUkHHqqQbJvVjD6rZJe1YoBpVKcPaG8p/RJVU="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-mGymtgCLHafeYFTA82T6Ruj9MsbTJi+oiQlntwCS1xc="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-NavF+UDtMhTRiO1LeN+4UvOrr4cmJDrdvi0C+uCB85M="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "8.0.7"; hash = "sha256-f5lV1hSHDoP+mzLEtRndiepCDRSQCc9BMkoZ10FO27g="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "8.0.7"; hash = "sha256-kfJiiNrix0/dfkKyW/Fo6SRUcZRE2ufaJe/7u+gMGuY="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "8.0.7"; hash = "sha256-qT4qs7VGoiD8STLc+9/Oweasqhuzjo5o0479owprdo4="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-SywZF6WpanKLjK/Agd2fg15jiJyg6ipEMOGIk3ov8rw="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "8.0.7"; hash = "sha256-AmO3HSbELrEOkylAYu/8guY4RAFTGybyqB9o6Qggu+A="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-FHDfZkRYJvCoZmShUjFaPntkS4ekKjYqM2G6Om3QmwM="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "8.0.7"; hash = "sha256-57qig8jhQTyHa54iGsIiWli8sf2lqc75UAVKEu1eIIM="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "8.0.7"; hash = "sha256-ze1/X4CPUGJSjKXxZH/SQpm7BWjWcJARxqqWH70wEhM="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-xm+eRqJAjcR03YyN0CkXBx8/PeQriUcBp1PmjpzPigo="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "8.0.7"; hash = "sha256-fN/p3EsF88XH+lH/JwM9YjEnl67WfreGdGBkhcRVwF0="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-J1hXKVo/2+s6EAaRCeAOfpy+mY/uHj5+1J8jkmg43tc="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "8.0.7"; hash = "sha256-AptvL7jkaOXNo82UfCHw2pyu2oT1RaQyPTnqErLzBng="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-TfM8MOsT1f5Yzvru21SZfSmWr9U7RkJQH4qwOw0FyY8="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "8.0.7"; hash = "sha256-xmaCkREdoHrVOPuFgRe02lavelIXy8EejP1Mzbqar4k="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-/SKPvKib4tlfGmReovNBcNnbOCH5tI+2XjK63f/64CI="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "8.0.7"; hash = "sha256-mRCD5NP3wtweY3bycRN771EHoeanG5HkIygdo7T7hcs="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-PdexwXWs0Bu7PNkkXV0zKD+fb4oum77qawDiIo1ZLOA="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "8.0.7"; hash = "sha256-U28dIRDuxiccu+dA1mahXzIpHcvabObyqhQBDic1pCs="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "8.0.7"; hash = "sha256-iykLWHnmHRc5UKiyk4Ymi3beFIxJ7v6OeNokD8weFes="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "8.0.7"; hash = "sha256-DUfqCuw0mLD3wzroAoA9BC35Qv0LZ38edS0hWWm4pSI="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "8.0.7"; hash = "sha256-94dHSlIjmexH7YFJwpypKV1/agrv9fMB9ViFimH25fI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "8.0.7"; hash = "sha256-1U15/HnPzA90/SQkN8xtddR+HKmPKPft4dU9P/0t1Ys="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "8.0.7"; hash = "sha256-17jGHzqhTkEkT7vGv3J1QLMa0IIFTL7ZozEjxSAc8fI="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-SAWxq7EZzBRHqlGhCMS0YwkxeVDVEMdCPJOeV7bWsik="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-ee7glotC63mP5WUg3HbAFipuHc4JSZJeta0/Jx18hnU="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-APvp47y8fDE1uFucTyZ8pql82aom/Yb9OhHqCHTHv2I="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-VS1bTjLs+PgL1AuZG/OjGXs+D5x2q+yGbtAKZ5RYPUw="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm"; version = "8.0.7"; hash = "sha256-qJGjpAKvtRb9pxPGwVhTQsyPTk4Kfl9Z56keDVF2H/Q="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "8.0.7"; hash = "sha256-YiBHc3PC2qms/39IvJkaLfe/Eug9W97bz78XKKkqax8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "8.0.7"; hash = "sha256-ffTw2G+T5Jk7v57tx3C2DWOXbD0lCu4IJf7v61hNnu8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "8.0.7"; hash = "sha256-cQfBGSoZfnuBu+G5dWWxdxy8MzChoIpxWDvkkN98Z8M="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-E5NTiS8SKxeTPxZVx4HJeQAhgT+to9k2lfOqZNDSIKI="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-5pPn41+CwhZIo+U9zi5IIl0LwTAqKX/pfXgCKQpF2v8="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-JSeRTYEWm38cTV+zy0J418CdTtIaryMYgUAQO9LWbx8="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-WJOilD+MFQEY3YGFXK3gmg4INk50qjAd9pC6Aadi/B8="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64"; version = "8.0.7"; hash = "sha256-/IaiIJAxfwGDYbcrTjHqNh+lfwr1ImNIadtWw8StN08="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "8.0.7"; hash = "sha256-s6pb37BjE7TMBO2lQexUoJ+m+uhPB3unTR/BGYG+mVI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "8.0.7"; hash = "sha256-Hi/PhR7YDn7kKLcOGymy90BX+a9jOTmheLetKlOuhW0="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "8.0.7"; hash = "sha256-c3ekBpJZOS/2JD5KkktVQRVesPxTJmzpm05ROVR0mxo="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-i7qpife+v7/1ymKa26jQ2Udm+BAxWAl26fRqEPZeQxg="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-XrNp0SM44cS9P3FO6Eg7QSceNVvvfiz7Z9vxH36XGbc="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-aYx6Zx2rvP0eyHD1HRnIOOQ3Gb/sA44cu6j6hZ4402c="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-PNYNnT/0YKW6l3evbMT5SzFpfRPDJjqhKpK2WUJhLtg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64"; version = "8.0.7"; hash = "sha256-PHVtlzkrkjEp0edQiFC3o2G7SoK0Tcu4qNsWvBX88ns="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "8.0.7"; hash = "sha256-9ADbCAMxEgsGPlBjuBHxWivAmAXZN2hr2SgIXOXw85k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "8.0.7"; hash = "sha256-RzPUST5VXIAlMoLUSmwJCEvH2Pp3lnCdQBaj6ijrv5M="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "8.0.7"; hash = "sha256-HS8emZ5XWdTVrYPOe5K7vx9RURl3MLZaiutOtAVqzF8="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-GMh+zDKmRap+DrWJQve4j2cnz2D/8yNxsHnc4fd8FC8="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-+boHBCjSgI1IPg8GsdueK6a/GEMY2La5dnY3z13W4xQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-exodwmW4mMb+T9wpJ4oPZUbMZaPNQi9GYGgMLJ8VQps="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-yr0T47Ix38a9RgVDAfHgJlw9CKcm8Vdjtp9DUZ93yYY="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "8.0.7"; hash = "sha256-kjyhOmqXN2rBQx+oE9TIgkokfBJLxc6WeuGNE23IH2Y="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "8.0.7"; hash = "sha256-M9AZVRoq+jh3sd1Ojwlj/Geglr+40RvxYg2y/T4+Z1I="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "8.0.7"; hash = "sha256-2Ne+4YGJhhzLiEZ1B3LdpQH71D95PA3bqTE+xr4YTgU="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-20Y9yKvsRs/ohbXg06Rrv+EkrFBMo/PZaOqG53x66yc="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-/hksfydKOPm+K9qYevmHsd0YVTCXuJwAa6Cm8Ps3UpQ="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-nsOwWRhkKitNQ9X3799YiatvvyEIHv20q0QeqcI5LmY="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-TEzSFRcVzomarLxc0vmSy9LaTwQTcZouyxalA6cSySQ="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "8.0.7"; hash = "sha256-lq0qJfRz4tMeVfePWE4q2S7RXDTgu6k+wtAlarSTEdo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "8.0.7"; hash = "sha256-ZgMM4TjYHPGRfo8zJdaEOunQDeNR+sRPP8tK1W7vm84="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "8.0.7"; hash = "sha256-Ks2GywNlXigjO3agtL15VvXWFx0RYRvKxQUiCToZbeE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-iIT65nO8Wszkw1HZLlurThevrr1DqRAESVVt2DllkJE="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-HLnS2tfcCYzb0rsjEPKiw91SPV9iD5Mfn9L0FyXqLfM="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-AoiK9Ii99ppr5cmGhar70CrYWgvPI3uu2SbFmyzux5I="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-/UOgY9NYf+KmUKgPaalfMJA903nHdyJRu4VvuVDsrtM="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64"; version = "8.0.7"; hash = "sha256-cgqYyfVXJyn5EcKnEF1404N9LNw3c2cCYfOmyz+YyUs="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "8.0.7"; hash = "sha256-zMBpSXV8dlGI/3ZB9Lx4qQnAHFNCwsjuEAuQzxHWDJU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "8.0.7"; hash = "sha256-cNQHG7xlOgB6o3u0h2+n6uA4M8abci2YbYXwYaXnnbs="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "8.0.7"; hash = "sha256-RNzRuZH5j1socRsKmzxRLDdQZ/V9FRrT7jdbxtbOSI8="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-FpKoX8FjwCRqoeqfawbC5F7gu5/QTisfXM9dWgFQBaI="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-l/cu8tR1x9HLrQho+QNpGUvFMHPV5vCmnq0JyNoP+cs="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-0FDa4DaDV/2HZjT44MeKKlaQAMJkHtodCoFfXsRh/6s="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-eMzHQs6kNKyj0qn4i5xJscZTyX9E4AxbGpgmkgCb9wI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64"; version = "8.0.7"; hash = "sha256-ee+hxp9EGI2A9Tode3zO8Z0f5Vji1YZemKxWlG8mlos="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "8.0.7"; hash = "sha256-TWXhiLxVkTem4aoBfWpVEhbWvfECfqJQqFP4X8BMhCY="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "8.0.7"; hash = "sha256-jlJIQtWuE/CqRuwCam4ucYq1OROQzicouDeM3brpNTI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "8.0.7"; hash = "sha256-SN4fTW9O3m2uHQf0B15UXT5Cdxf23SJ03rQ4ye6FR4Y="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-sEJVew2/aDe0zkXvq8PHhlgVaj+eY22OELepWxT8D1g="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-pRwdbcPA1ci70X1HlTnHS/LjISzk2wghf83WHsfGgzg="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-POM7B7N97NBpPgYxkdv9J47YQ9kruVtxqybTsUv7EHM="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-MmKfRBlW3MPFuGjMBnJP2vavSFMKG4MTpNiUog/ZVhg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64"; version = "8.0.7"; hash = "sha256-OV6KxOTGpYAhgLA7euaB2QYD++DvpjioOGmZHeR6c3w="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "8.0.7"; hash = "sha256-gAhk5LDRxVIJIbh82oHOuJmyez6U9wxeFLOGQjupGLo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "8.0.7"; hash = "sha256-h3YTgrncy1VeAm6Rp2bF6Ht/rgmIt1SjqKjZ37KUKrg="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "8.0.7"; hash = "sha256-X8uywecvgEye7lOfZH7fO9UBSZYWtbAx3Wz23cGUi+0="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-xnkbL6gPKXfBSuLczbQUeGt2NjxSggXFbyW6Ry47sqY="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-8bqkX7JyNR8xGs4tr904msRAzMl0bkxWk1RATlGVCUQ="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-CUo/aDpFMmvikIQzk8Gz6KljPaVlEBYlTmvsmoYfyWU="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-IfUDna/s53i8lR9VGd2itAhyvdrQchN88+miOejI0hY="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "8.0.7"; hash = "sha256-QQy6f/lh/b0qzP25Yp4M3zOchq7dQeJazVcUHWhpYgE="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "8.0.7"; hash = "sha256-QgO8fe5enNYneTnpxBFPVvYt6DdfIo9YE81olZBgTwo="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "8.0.7"; hash = "sha256-T2cZ1C1FCj1vhADB7fGm6H7q0BlB4mDnvF+qAnaeU1c="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-tDcmJoa2grbScwuj28igMEK0C7XAPVhDnVKV+Vm+mXU="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-jG780cisD85cXdmwwrqYaBI9F2lc4ILrodc1Kj9wgWA="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-8vXCDGvIvd77yGVEapGZZ9jiLPj7dmk9KsVhspHzIHU="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-gwKKGjRakQtE8jvQb1pkRqxAPpc41ZYhjASeF/H02WU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64"; version = "8.0.7"; hash = "sha256-COqr5vND6W08rXarNfUH7NMiiU8Y78nf+xRcCACz3Ls="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "8.0.7"; hash = "sha256-b9/de+HVcacDwBWzQCOxVo39ZhjbRMvPfw735cXlWHI="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "8.0.7"; hash = "sha256-RlhUACR4s1jWG9sb3gbbhoyhnnmPz2KennKWBF9F59k="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "8.0.7"; hash = "sha256-n03qkdmKOQg/Jm5cN8PnK0NMcZaHdmy7noIWRL7CYnw="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "8.0.7"; hash = "sha256-lTwIKMi0DN4z7mzQ0AEmr5BDS1r7W4m7Ey0Kco4RTio="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost"; version = "8.0.7"; hash = "sha256-AuXy8RVI4MJv4njBUcQ+V4vqDnexlO44LMJ986AMVlQ="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy"; version = "8.0.7"; hash = "sha256-1Gl5ETx6ozeNPbqbegOg+6j/Ey84mnqktM8ylvL+FzI="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver"; version = "8.0.7"; hash = "sha256-n+82uz/gjgFNNF/2LYmzyQH8DZeRxzkEGqKg8r3jbUU="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86"; version = "8.0.7"; hash = "sha256-WMhPcFEwSxoasMc24nd9PQis7h7Po9q/wY5h0sEfPpc="; })
    ];
  };

in rec {
  release_8_0 = "8.0.7";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.7";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d37fc703-70c6-46f2-a5a1-b60f45fd71d0/6a74aa0bb89feb7f795df1ea92d030bf/aspnetcore-runtime-8.0.7-linux-arm.tar.gz";
        hash = "sha512-0BB0QSI6RPHE2foIwtZrGHXSCRf7Hayrf4CkLw2hQoVw3Ry4a8H25O7zQU4XcHaPyPF7g20Perm4kISLwYzosA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/421d499f-85cb-43dd-97b2-8ebfd06dda8a/61b03be4662125e4af044c7881e66f0e/aspnetcore-runtime-8.0.7-linux-arm64.tar.gz";
        hash = "sha512-Xx0xsO/Hk2Vav0KJ+PHH6M0f+r/WWzhbSeP1IyJ3xizPu9rSpRcxqKiFlKBsLJd044hlyz9+GcmSWhKyW0C0hQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/06cbb934-ef54-4627-8848-a24a879f2130/52d4247944cee754ec8f4fd617d502a6/aspnetcore-runtime-8.0.7-linux-x64.tar.gz";
        hash = "sha512-x0edwAj853wr/Koawcn+b2Tvfllgn/9nB9oUl1qt5z48siuX8rOSKiZC+o2EOjyvcUqzorNXq+2khrnQ+L67GA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a3898e56-a160-4817-b6a2-712c5cb64266/1a465710acd917f8002548f426deebd0/aspnetcore-runtime-8.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-msyLyMX95pLe+Fsd/6qGSPzGoqSCwlKIJmDs3EyotL6NWSdIkb+5sQbMpihJpwW0gu9bTFOQFOKE3CMJI0/+Ig==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d7c07119-b207-4ded-b41f-2f3fca16099b/4463b6690425cf7faa37519dfbe89a46/aspnetcore-runtime-8.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-yluNn72+PDj1YNZicFvgAXSIX8er2HWsBWyXeIQQMpr5AX7GBSoUa5QU0m/5VqzN/cbvMVqvfGk2sFIKkyBJPw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7fb2c473-d403-4347-83c8-243b9840d7f1/2aeb8220ea65ee119627f6145102599e/aspnetcore-runtime-8.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-pg1HDe4aHaNM5NnoSm3KHn3yu7yLOw/ONlQ/cSuKPaeKPd9ZtKwjGYb0mm+0T1micKGE+rvaag4JjQGNPir6Rg==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f8909467-b187-4651-86ab-6edbbc21f6e8/f07e4a0141b3907f83079c0dd44188ca/aspnetcore-runtime-8.0.7-osx-arm64.tar.gz";
        hash = "sha512-8C47Ok7DZqK+fvWW9yiRT7fDgQ7VB+vK3iewn/YufLhM1LJMhDjK2nK5nmD8dHfYaKbLVwg6OTh/eQCHT6o19w==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e2410d8b-380c-400f-ae85-c0451afc35e1/cf601795432ee94bf55f03f8fef08e6d/aspnetcore-runtime-8.0.7-osx-x64.tar.gz";
        hash = "sha512-hndlJQxasEMQI9Wbn9BKwKyGh5fi6htCV+RNkwM9ZT5I2Hdrt+fLvewJSlpgAC0oM8WlgJT+VMK2QCsc4ogsSQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.7";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1dc20d39-a5c4-4e23-a70b-842fcd6d603a/814d37d9c67811d9d2837905e4330eab/dotnet-runtime-8.0.7-linux-arm.tar.gz";
        hash = "sha512-zP6VqVvjxk1WjG953zkdr3MwT6LCrt9GFs2Zge/hHKxpjBV9g3XaOv2mkbeBJMxmcv3nNTsP6k1F2hXgAwQKKg==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/710337b9-9cb6-4bc8-8d13-daeab2578a08/b3ec8c17f85e340820a0ab36a3870168/dotnet-runtime-8.0.7-linux-arm64.tar.gz";
        hash = "sha512-meaVmhFW1avI8Mc7PUk/weEKQtSKVzIm68+9+Wu2+xyHAdtbNYKkMDziak94TnTrQCy25eS827Xfq4/qIhz+Ag==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cf3418ca-0e14-4b76-b615-ac2f2497f8ec/2583028ea52460cb1534d929dc7970fe/dotnet-runtime-8.0.7-linux-x64.tar.gz";
        hash = "sha512-iOmsNK1ax27sVJny640ao1B2UYyEKFTsEFOVPTSWnHvxxbLbziRdus46GMO4pMedLvLS/xBc6dF8u9voE9ixbw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2bb39900-40fb-4a9b-8c6c-17a46d2022ca/8fa92b782e35d1799e987487b06da37e/dotnet-runtime-8.0.7-linux-musl-arm.tar.gz";
        hash = "sha512-A67LNIqZ0K/JuQAG4UoMde1p9+9suGifrBce3w+Iqqkoo5XOQzo5DO4cpCVVYFEcidjYJ6V1shh24uf5TVvO7w==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/131bbb56-05f0-42f5-bcd0-7f34519c3987/88bfa5e29ea09629c1e62857402cd466/dotnet-runtime-8.0.7-linux-musl-arm64.tar.gz";
        hash = "sha512-JJJGCCSY0/a1o6A0dSesWpjs0P3iNda7SLsY5LsDHtpoM1JgNSeemel/u13Fj7oTLJvtXzNELEflcakfZI+oYw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/938cbaf9-8ed5-44c4-bbb3-fa982add0482/29c59ec494a4349190c29b2d03d8957b/dotnet-runtime-8.0.7-linux-musl-x64.tar.gz";
        hash = "sha512-MThqOvbL7qPhsOLxCdECIsWtQQV1QP1cYmlZ7H0qVCuFnJaZy4ahrIEut/7ROdyrDFPsuK32eP4K0Exiz2wfjQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ccacebeb-3dda-4887-9a98-e2dc9a9d9dc2/0ecac27f49c0111f4877cac54ff873a0/dotnet-runtime-8.0.7-osx-arm64.tar.gz";
        hash = "sha512-ivZVVzNQ9r4LRyI65ycsqNSfs8dPb8Fn5ySSZ8FhaELuoJcJIFoHrNO4alrIYgJu0Saezl5oHD/VCtqDUcXf3A==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c0e3a3f4-d235-4531-a1f2-1ff969cac1ab/837430d708532d74b7296108a681b9bb/dotnet-runtime-8.0.7-osx-x64.tar.gz";
        hash = "sha512-CRB94ExnSPs9mNciluNHCm01UaZr/MMQ0r4PZ43Ry4yxOohrG34eOFbhLAdmzVAH+ZImJWU6bihPWrj8gO4ErQ==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.107";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/020bb759-11a7-49be-89f1-b2935c8fea05/c2df282e9aeabab835159e8a368b04da/dotnet-sdk-8.0.107-linux-arm.tar.gz";
        hash = "sha512-eCBltL+WkByRRIQSuyL7onlY6IEsq6CgLPjb8jM/cyC6LB7svvSFn0A064DQS9uFOhg24dKEvfX2I8dBbfyYYQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8d60cad9-ce0f-43de-8dd3-fa3fd39fae11/ce3bd2ec1177f519b45fe30c6e9bb74a/dotnet-sdk-8.0.107-linux-arm64.tar.gz";
        hash = "sha512-q0h4c4J2d/RO/kNy4MMlpI8zkAjQAweHbh5WeVvABr4XcOix+VgccZfqG/hX6uUlrKGJNFkfYDNj+P6eAh57Kg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7280c125-4555-41e5-8060-cd69e4e325a4/34e25b09d2c92b71215f8974a4eeded3/dotnet-sdk-8.0.107-linux-x64.tar.gz";
        hash = "sha512-EOD73FieXg3k+w/g6cg5uyJXxRlIA3oiTUNYuDKLZ5EBSrTLFkvrYXyDUxpu13Sss3sI5KG1PxZePrhT/UGpWQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/17620b9e-7cbc-44b5-ad52-7b93845b5480/277f76f99f6e33d6ca273c5647c5e61e/dotnet-sdk-8.0.107-linux-musl-arm.tar.gz";
        hash = "sha512-5uYyXGKSv0NaB3HDPq8zDcEyoRNy6m0SQn9abCTLbbJg2Vsd+7o8Iyz51RZvYRkqBcfjvkIQoFpmh2NPsKiHxg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/119a72b4-47c5-4c7d-afb1-1116f25bf03b/39b9016420f86e19dec95a08d8a7c4c9/dotnet-sdk-8.0.107-linux-musl-arm64.tar.gz";
        hash = "sha512-W5mgdgfK5lLks5LBenhW/7Xfk56V10HQfDhdQi5VETlFZ7UQIhPaHcZRg2gNDpCNg8Q8lbFL+r7DBcp3MdnWdg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/10822ebb-400d-4ebc-80eb-f81fefb5b126/f18a8a171534bc6c28dde71bf1dbe8a2/dotnet-sdk-8.0.107-linux-musl-x64.tar.gz";
        hash = "sha512-8lyV+az/TbFlk1Qf2lF8Mkd+thjcmtWzmDpKtb1i/dPAPH2fVq/hEyr/UTe73EFh4Lg/fIEByxdmuC7UByvs7w==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/2bb0f88b-19ab-48f3-b0ff-146629c3ead8/8e59918475c54fe4d881ce8f5bbde2bc/dotnet-sdk-8.0.107-osx-arm64.tar.gz";
        hash = "sha512-spP448rSAnjuheMLSxuqYVwwsOerpVex0CSNnlxFV+Mjtyav3eA4bAIn1svG+VyO9Uk+IJy1pCtk6Mf25JUiTg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/c26fc34d-c784-4c4a-a2b1-43bf3599d4e6/c3ebead0223edb028c7e53eecf37048e/dotnet-sdk-8.0.107-osx-x64.tar.gz";
        hash = "sha512-m8YlFSIPkkyt8C5b6ID6gTttCwz4whmafpMOJegVdv8+iIlOWgtpHYsKHjL+GrRJn/R9gM0ATwevYdbTYu+2VA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
  };

  sdk = sdk_8_0;


  sdk_8_0 = sdk_8_0_1xx;
}
