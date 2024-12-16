{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg { pname = "Microsoft.AspNetCore.App.Ref"; version = "9.0.0"; hash = "sha512-Gw0hOfzWemlJgdGucGfWdU0H7kFmE57x1lFLNJddRzbGi6r5Dv4T9+ySMXHj5MEU09iBRUig6rxsGu0XDsB1ZQ=="; })
    (fetchNupkg { pname = "Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-pJWUhSWVDFIk8Cq/lWdBuedQk2m+uWBqKvGCmkpTXrx+22s/qE+D5gNvqMNX55QyyERg8hK3L3wMpbFkf2Mjyw=="; })
    (fetchNupkg { pname = "Microsoft.NETCore.App.Ref"; version = "9.0.0"; hash = "sha512-s9us2abMLwrWpH1glRbjlMhbwCLvq6MhVBwcAjCqeD36kgBT6rx8PA9Ro8W6715QvRz9luJPJLUd1A1Im5QjAA=="; })
    (fetchNupkg { pname = "Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-VlXpaCL4/ZBq1vlW/58bwm9hNd2MXRiwPXhvfclsLMJ2j6fJaaX2AmB3XsgIWYlageW0FY1v+QmyhrIfmKJGxg=="; })
    (fetchNupkg { pname = "Microsoft.NET.ILLink.Tasks"; version = "9.0.0"; hash = "sha512-xg196uBfnUmJlc5aizfTi588MyruI9Hlvaqj3mMbx1J9GfpF+t3gdWR6uKbH0lVW9oxzJ7FgX7NWZEZj33j0ag=="; })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm"; version = "9.0.0"; hash = "sha512-MkXLF7urjdN5Qk0oFktLozf9TlM4q7WP+6z4eHa2Cwu3YWWnsbkxjTg+z04nNZA9OI0LLMRrxrJyVEg5HuIrTg=="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64"; version = "9.0.0"; hash = "sha512-Dn/V8lDW3q3C/U13fkAn1wJLNgwZ6XaMcb0vOXZROW32Ae1mEk9jFOnpRNbzCpFKQUGJX6Sg8/ift5ltX3/4dQ=="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-3FZilMq21HAH5zXmB0KL7WnMdqHitJLkzqw/FgEiVdG3rECHttxo09htp+jIenDs8J8HitoYW/Xw2Drm7UaU0g=="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-x64"; version = "9.0.0"; hash = "sha512-tnBxVIvOo6DjRViwBjJcyljpsMZnM46Y1vBqM8AbMM1fO0BcKPbJS88GmnQ3q0rNWmi6G2VY7UYHl/+9phcGCA=="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-m9rQyHa8k6tmG9ZV2JyXYqG8o1gEFw8uh8mP7lRKWetA1ceXjPfZUEwKBXMxa+749G2ELibL696YL2YY+Z+C0A=="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm"; version = "9.0.0"; hash = "sha512-URG+5zlHdvC03qzMEzlb8i8bYaY5j5BaVm3u9+6qDE/1xcb0SZrzvJK2TS5UjszUmCEyYeloFDBx6FQtEk4bag=="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64"; version = "9.0.0"; hash = "sha512-Ycj0j/VDvek7/rM8hYldSVHtkk3UBntDz/D+iwHVF3oc3QkEyEwPQFhM9uINEFTHIR9vwRE4DdhQfTgdsvlong=="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-+64gZ7mG3UKNt0ijOiYcyfVBGsFTM0n2Buyf6EFJNTExqfyaH1G/YjrVO8XM4q2KTV5MrWLSYyhIVvl/ZhaitA=="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64"; version = "9.0.0"; hash = "sha512-kdpajBOhxRjilUH7obuBN8Vj4yTlZlhemNTJ6FTHp60hNv4cINCs7IEnvzkC9TNuDAJNJyP543y+61QpIie4Cg=="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-S3FR1/F/xxAA/LkqaPT+v8lWXxFvTJsCqyhMtFgYLKlAseXtZx7KE6t6a8xEgRJ5mdjA2d+MJFijfPw7ZKfaPQ=="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64"; version = "9.0.0"; hash = "sha512-2xbup0BwwwyAl9zH8U4WFrs0lh+24/WOoVn3xCaFZ4dzCpScFzE0qLZNhlBkY/EuDrbpVS1xf1toWbsZGju7xw=="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-wMon7mG3IkoRuzmtu/XSaUA7k93y7zUp84/cIzbRPHn2kc3bpBf1ICBgEibi+buNAsicGXgDa28hEjlI9ij/vA=="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.osx-x64"; version = "9.0.0"; hash = "sha512-KsYxh+x62uTiWcHcFPoB4inYAShiQoORJf8mUtqdpI1CEDgUNtnCM5jFiBiuCAekMfA9xNfy0lsU4yHyg8MjzA=="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-l4xnwu5ZQc+J++LyO+cMojdjQw48IdkVqgmUc+SF/U+A6t0Apj0RCtB07XLDtpFzTR9HPY5RaE38+AZhE15Uqg=="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-arm64"; version = "9.0.0"; hash = "sha512-JQxa7mSZVVL9H6s/R8/5UOZSe8EekbTE4u4FFVydSyxi+mqryNTGC2Cf7YgbfFzWasDEqNtoSOhqXA7MJFHlDA=="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-xrNYFUC3PWZuZxiKKBF4Re/zsyrA81uLMTnEENkqPdYI6eNabAvcGsBi7wP5mfaFtRWPbete5k5S+kOlpCpw/Q=="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x64"; version = "9.0.0"; hash = "sha512-B6Noyuo7Nx6lH+scXSUE0J8IxteoJWzpdgXkb2CO3MhSeaL06KLg51q8ATxmx5gs7emHV4sHxBq87k8U7KZxuw=="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler"; version = "9.0.0"; hash = "sha512-P59aR9VD9GjI7ONAAK1SVjEJfZEJCpLFo9CVLe8raRdmq1MWg/eQ1sXR2AR50GPmciSCBpIq8rDAYZLsCiLx6w=="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.NETCore.App.Crossgen2.win-x86"; version = "9.0.0"; hash = "sha512-19GSA4/P5CMvqjkInp7rBySTKmE1i0KjtYtYCv5TAesvFbyY+tJRQjUJsHUB1LxYqdi7MNXR6jvcW1O6x67K3g=="; })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm"; version = "9.0.0"; hash = "sha512-yNSYhFO714aiRTgQz+NSxmZ8KaXGYi8MtTyP9pG8H3Q7tQOPvhd3EhJothBasIjNGHeVoedQRBGXLHWLlHr8sQ=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm"; version = "9.0.0"; hash = "sha512-doUaAKbTQQTvU+5c0WvENx822NekyJqKlfzLhNDh7v7lC/syq9RUApQxyOffWpLa7a11L9r7yf02ZdKACXgeyA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm"; version = "9.0.0"; hash = "sha512-mDuNiquAA808YwpS+Z3RKbGYnnx7VCINSEYWYNUE55HBfR+lSe7NxRB+Ed4XxVOaBbeG2aP/yqzJjKEYP7kNew=="; })
      (fetchNupkg { pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-VLRDQ84utnUvatZO4YTkHJCwdWgHm7zxxNEZ0xtp52dDBye2UVcwXY1ZNrKx2vRfKi5zTLHbOi0fGTAbK+TLOw=="; })
    ];
    linux-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64"; version = "9.0.0"; hash = "sha512-DyQUA+74c4fjGgqGpTnXXkT5r03GSndeem3J7F2O+WsHg7nn87KHi2LR9y8RJWXHD9ceSOVMBvTLulM+VvRuOg=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-arm64"; version = "9.0.0"; hash = "sha512-f7cPFLvJA1v08v1EtfcC8bKE1WFM6AU2YhhKrid5HZLDD1e71TXFMT2eLawwsoOJxnKG+rD1ERtySgvMYPWh8Q=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-arm64"; version = "9.0.0"; hash = "sha512-0v/YP+0hkr7yzvzGKhNzS9/wAknQtH6uH9k04NfIp5inCjq9LxWsL+S4YCINDwVX1oVeUS//AVv2T4sDuhIzjg=="; })
      (fetchNupkg { pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-J0HoXQwGxVap8DLmheMeYu+Gr7UR4k51wV+q30A9rfaT33WJoWVe/aheXdYDgkxmGnKK/Cr8ScEDtD6oS+yb/w=="; })
    ];
    linux-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-x64"; version = "9.0.0"; hash = "sha512-ah1ir1EEeGSshjAkKp8lfdl44WOYXFZmcydvORnQIs3IeKCkwhQTZNkgZOwieT1NtGB0TLbc0h1FSV6sURlnuQ=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-x64"; version = "9.0.0"; hash = "sha512-va4ruzadg4nK1wM8PzDoqLFTNypO0kgVVkiV7+3wKWuYflwdYwWNpae5qKjmsLB0uLNrljBT3JSErksU6YpfkQ=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-x64"; version = "9.0.0"; hash = "sha512-tT2j+X8saJn9J+3iM6MoJwv5kEAhWyuwPeZZipq266YDIlwEaW2FDjoWCJJVLC3vCDidHlnTT6IKUv/LMKKpWA=="; })
      (fetchNupkg { pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-DEuteVFMIIUgkI55r+/kTQq2PMcaxj0iGxLs6CG9YFbfwvHqduq7MA2pqdonhL/6Emg1qFASw9LafjaIIfBqJA=="; })
    ];
    linux-musl-arm = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm"; version = "9.0.0"; hash = "sha512-cjxki6OzyNfxncBFL1NjgXruHitIQjlyxjwXewOqkNqYU2EOxyKWhcxxOzavgw00x/izuvooDrvpNari5cSJng=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm"; version = "9.0.0"; hash = "sha512-PkTgJhN3fhoJuynpjWPi7JZyGgOJ5EpwKWtOUPRiXLJj2Tqp3gKMdYvZz4pjEJm6KK+T6iWyUZRUr/WYRme+UQ=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm"; version = "9.0.0"; hash = "sha512-SgafbwsE40tFUABR9rlfA+9YQenUei89fakk0SlNHUZPX9tkhHo0A5gXY3/Sdt88HlLOUCD+pmM7Nn8R2CdbBQ=="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-aLoTcH9BTv7AuFML2fiqFdha09b8ETG+OJTP5mx7ER7taT9quMoUu7WJk2L8r0k/QdBoxh5qcqLKYjRVCoQ6IQ=="; })
    ];
    linux-musl-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64"; version = "9.0.0"; hash = "sha512-penFoYejLCetGFWNXlUma/LbCZKXQMzGjKaoTMLupQtvjc3ZKM/i+n7uBXbRPTd3o9kYus7fCPtNnjk9lI5cPA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-arm64"; version = "9.0.0"; hash = "sha512-nVvMcj58prH57guq7lLE6de9KgTjAt18JTu9wXTsnNwQrOyAgZevzM3OpB4clZ1aqkqCKZZ8fuMgpPEbfyaTCw=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64"; version = "9.0.0"; hash = "sha512-jqfZ0ZboGYYa0KWArvYaO4Ddw0TMnLDkYVHtgKVfdFlaVon+KpM96yykbqmHLr1UUkDXDHNNFtHwnpVXmbmUOw=="; })
      (fetchNupkg { pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-h/AXFI687hBz7iO1okAoLFG/r6WNvjqMvwu2IFFN+FtweYjH0MOXVR05fG5Gzqi+RhiNkcF63b6IZDcPvEBKhA=="; })
    ];
    linux-musl-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64"; version = "9.0.0"; hash = "sha512-LQmhF/z9n7Bp8ygYDpY261u3BU7QscyXfLwX52TFAXaMGNCvryVW5+92TeK5wK9zorlAdZMK5+T4sEeOMMa2PA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.linux-musl-x64"; version = "9.0.0"; hash = "sha512-2qPiXsxgMn//ucG3xnTJX+kkpL7/cSF6ve6G+9voJk4Y0abbr3kaJqnmuSRIFoRi6gQt73FBEB7U5mcopeidSA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64"; version = "9.0.0"; hash = "sha512-7+1WIq+1cod9u6RBu0c5nxIyYhZs4PHPQ7xvFu7u67JiSk6yGZqYStoYSwphme7D6VPqsyzzSUG/92zgwNg+Bw=="; })
      (fetchNupkg { pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-fYyTxX42IGf6v3qvEsIwnmFjfPCYO/yQFQizbZ64Y1GejNl6o6pwqS8BMkOQ7gV4WTaO0aQwPigPWboyCp139w=="; })
    ];
    osx-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64"; version = "9.0.0"; hash = "sha512-x0yxetXr1TKLDGONxhE/xl9726Q9T/iVQALK0wtZMdIEES4J7XehHnzA2+jGK3vEK5ZkevAN9EE6Hoijf6+iGA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-arm64"; version = "9.0.0"; hash = "sha512-SmhcN8JXFuVkmM32zgDtMWP9GFM3kimGr5R3FqzvlLXc1LVndmdsEcvCsLhmYhjr69hPBZtIv6av/LAxiIoKMw=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-arm64"; version = "9.0.0"; hash = "sha512-pc7A8emc9Rl25slknnQyYSMAyHG48JXAissa9EaOSX8xojisl/GU0sDJnWkZkrd4RERyhekpaSoHGS3znLcUUw=="; })
      (fetchNupkg { pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-Zruhm/0uRZ4036v182pLQ/SvqdQ/taJ5zxErdP9LsLypFFCRLWODpQBaYX/UZgQLFtsvv5ri81UZQZboRv4TNg=="; })
    ];
    osx-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.osx-x64"; version = "9.0.0"; hash = "sha512-8sJ5cWWtGGMG+NFNOqzzObgaBKAXrewTLMh5b0iHYIgyJ5KoVCpEQHAAe3Fa+zxdVyrmhXsRTekazgEqDKrSJA=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.osx-x64"; version = "9.0.0"; hash = "sha512-DryrXoJ1Y5LAwNfU06r75aak+/raphHgkNwD1Ejy1b5bIPuUDD3VJRfAl0JfWw5e8hsidiA4WEVRdl1gy5LU5w=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.osx-x64"; version = "9.0.0"; hash = "sha512-SyLkZqTEzTI9rWVbdLeM6F2EuhImVo3HzCaqu7JrFHwRxjFvc6TYa/BxmPhbOiA0wZbIAk7B70EWPeXe/jxzVA=="; })
      (fetchNupkg { pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-9hG3q82Dfu/5HDoWxGHenwMHk10wZYCXAVzxySS+yJwaM2DPhXutXNIxgzSMVGnBD3umYfzrBHUjynvei3gPPQ=="; })
    ];
    win-arm64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-arm64"; version = "9.0.0"; hash = "sha512-APQNj5uwHVbZ28Zvrx7CLEciJrNMTHOh78lvSNp/gpXgHkD4G5yoQSC7sj/B0AqSshrDs006WaCbp3PuTrKIqw=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-arm64"; version = "9.0.0"; hash = "sha512-2MkdFDpDUQFBNJsytmLbyv51Jeyl7vG4NoO1ekWAhNa+ZzwVOtgl3VJNlHgsgwGqyYc8VPmbT5ZAFrBNSR3hoQ=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-arm64"; version = "9.0.0"; hash = "sha512-mEW0ITYKnBCRuXQDvFkasb4FaeV1GHobQGb6r/DRZED/u4b7qK9QMA8jDr29LzHdfGlZJL7dsBVyUfjOAvhuxQ=="; })
      (fetchNupkg { pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-w5DtpHfp82nsMcSM9lyOCEj7pxohn4b8/m4MShhA87WigKB6tVdA9j6xnjC6eX16OvKkhbQ4xJhVfzt3G1d4ng=="; })
    ];
    win-x64 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x64"; version = "9.0.0"; hash = "sha512-BSXo3XZLsboJN72at4TMCxsZL5vjW5p3dMVtqedpXkmovGakcW0loYY22aCt40JC18i6QbsqzII+/jtTFqRoJg=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x64"; version = "9.0.0"; hash = "sha512-7SEHvvDPaYhWyNhUAurZou1oPrTgibn2k9RBW+falSlmXPq5AIqNi4EODJUbydc1QyyD2vQjRVgXvhF6aJ9s1Q=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x64"; version = "9.0.0"; hash = "sha512-ugVn1CngjzNdGzUNJjzukCwrV9MDZ7DhwIQJMHjFPrF9e0SMHTx9BnY1VDqM24AByFrsyymvm1S4Vj540TpGag=="; })
      (fetchNupkg { pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-ELSZhNXrn/PdJ/NBJYdDIVR3fhHY3k4y3gbRDqWwQZioJS3q9g26bvRMLC2dlXC5FhFRFuCTg4vGuK7f6JPPYw=="; })
    ];
    win-x86 = [
      (fetchNupkg { pname = "Microsoft.AspNetCore.App.Runtime.win-x86"; version = "9.0.0"; hash = "sha512-eG/2FruILBj/2d1Viu/9gbYuwXIHGL61UKvvRCUGWIgS72E8LQgqSntuGO83LOk+aLUHVn5cXrFkb4bVTCGB7w=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Host.win-x86"; version = "9.0.0"; hash = "sha512-mohCLeSgM6dCZB79u9Uz6qgnp7yLyEPszlHPPXI7R66mrot29ApMwDyVjFYNDv3eK/pcCHOroQKcH5qbnVr6pw=="; })
      (fetchNupkg { pname = "Microsoft.NETCore.App.Runtime.win-x86"; version = "9.0.0"; hash = "sha512-CsjUwZKARvTkcPSQuMIQwaMnKnH40SJVS3F6LTWKSHvy3BXMAdnXAeB1DbAegKZyIaRrqjnIlBv9OJ7/G6V5Xw=="; })
      (fetchNupkg { pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost"; version = "9.0.0"; hash = "sha512-PatJv/4NYdABL0jlheOf7mNhMUXgIH79pdhQz4lKFWgLnP7dmiGF102MbFwPs5X7jc1bbPAYhr5wVeLhukN7WA=="; })
    ];
  };

in rec {
  release_9_0 = "9.0.0";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/84aa8e86-c6a1-4562-84f3-828e836ef26c/96772a224b9ff3be8904b63f37d7cf63/aspnetcore-runtime-9.0.0-linux-arm.tar.gz";
        hash = "sha512-9xGvH9F/aXbZhgn+ujLbyLAn47hRQ5qw1aaAgrpvqH7jiIz9jN02i5D8OzcQIgvi3phkq1ApfjeXrcS8uqt+mQ==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b2029a3e-c67e-4905-ad1f-08b164322520/bd68ea0b77f12df21b935da338fdaf25/aspnetcore-runtime-9.0.0-linux-arm64.tar.gz";
        hash = "sha512-1d9LVJpZyLmyvO5eD/qf3oH8PfdLKZq0mCCva8DM+4nuw3FOpVj/zdKhaCGk0ezcxk6ZgYBJeO4/8dREuBJWgQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e4791376-b70d-431f-bd98-5397c876b946/64ffc29a4edc8fd70b151c2963b38b09/aspnetcore-runtime-9.0.0-linux-x64.tar.gz";
        hash = "sha512-GoECPxGd1eWw+dh7DjxC34mCS5/LcxkqRnDMLGc1jNAYp8nJZSRceIPeRovaiMgdZKIcYPm8aKZVnXbzLTTOlg==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/59a041e1-921e-405e-8092-95333f80f9ca/63e83e3feb70e05ca05ed5db3c579be2/aspnetcore-runtime-9.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-lVjIczCM4nWjZ2Q9lTJxrIh34MNTX8FxfO8BPsN/Qhd/AT3YdaEnGb+dHBUztRWSy4+HGV0eOY5SjuXQsE98Hg==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/e137f557-83cb-4f55-b1c8-e5f59ccd3cba/b8ba6f2ab96d0961757b71b00c201f31/aspnetcore-runtime-9.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-+1JVYZ+gwQggILdQeJ6Gk2zBoHueMhKX468zavO3911CXCD66fTdnXbAsE1ETh5t0V/VRf7sD2qRN6ZHAa1GMw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/86d7a513-fe71-4f37-b9ec-fdcf5566cce8/e72574fc82d7496c73a61f411d967d8e/aspnetcore-runtime-9.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-CeNwlmTwmbQRb4oqrEs2UkfRHQ0Z7K4mKUneOPqdQcxsUhpn5bH/7NY8YQwem0FFm/sY9iudnTtRduOFbprTWw==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a9c3126c-91ab-4ab1-bc0a-e6bbeee7a786/3f848ed6f804c50f3a4c24599361e0eb/aspnetcore-runtime-9.0.0-osx-arm64.tar.gz";
        hash = "sha512-SqMDfluLcj9p1Z6nM3gNzstcjhevkk2UWzaSN7/61qahHO+/tttc+y4fKB4jhayI6CUxILGlL025MYYITyMPUQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b3d48d74-e9f8-4b6c-9ef7-6f5729873f21/2139bfd7650c0fd8ddce3195ada43ae8/aspnetcore-runtime-9.0.0-osx-x64.tar.gz";
        hash = "sha512-6neKeqfuzSxGw4sYcRngr9sCUydDVQpL28VqkSXjKKCJwWr3TD/+ZJJj9FbvJvX8O5MvTR9202pHy0GfIDxlhw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8f639af4-29e2-474e-ad2d-ad1845c09e21/d6a1fac24aa5bed41dcc8c35017a44f4/dotnet-runtime-9.0.0-linux-arm.tar.gz";
        hash = "sha512-+rVS322IQJCrofZYyIErU2npvqF+ah+QUUXN5RJ3K1fbXVz1hsbCt/Llaoy4PCBvDPdZS89C0yhEuBA1OL2IPw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/3ae34de0-5928-47c4-9abb-e0b8f795c256/1ea2ed5a50af003121ebf32cb218258e/dotnet-runtime-9.0.0-linux-arm64.tar.gz";
        hash = "sha512-T5wt1USvC4VAwWNSufAfdfgouOTghAV6MApN7GUvs9ZTKQbN1CRjmcwT8WtXGxdXWBLsL5wpfie77WeLr0sv3g==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/282bb881-c2ae-4250-b814-b362745073bd/6e15021d23f704c0d457c820a69a3de6/dotnet-runtime-9.0.0-linux-x64.tar.gz";
        hash = "sha512-UXa9aGN2Rs02/Oeoj4Pv/hBl+wdebUpGuL48M9WoOUdAV38O1Pi0+xP6af6DsinrVat/RcqskISb8DkqZw7Vrw==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f2566d5b-8b22-460e-86fa-94388974ab09/a4ae7832d06be1e5ef0b55ecc22b1ad1/dotnet-runtime-9.0.0-linux-musl-arm.tar.gz";
        hash = "sha512-l9wd3KwXfXO1F9ZRMm7EhOrFJQHFBsjIN8P5zq9Hbd+SnM7Om23CwKTn03hXb9c5MKiDWBRpBjGlYGQlJzNbMw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/51a64e2f-043f-460b-a048-ea79617d9a06/b3274372b27c70fc4da62cc994890f8d/dotnet-runtime-9.0.0-linux-musl-arm64.tar.gz";
        hash = "sha512-M1IzZNkxC3XZgZpIZrEgwDue95Rr02RrFZMON/8eIR3ilMipS0rWwcD30pHLcGAaQYjjltQlL1dno2ptvmhQKg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/53729aa8-9540-4ddc-ad77-4b7126b36b30/5156249a151c4d334c19c89bb63b940d/dotnet-runtime-9.0.0-linux-musl-x64.tar.gz";
        hash = "sha512-nDPXOomPqbToSuGERGi2kIaXn3wsjqazLbD+pipAFFE86gYZAl+e2yPmerSuTi8nJdHZu4koWLun3+jtF67nmQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/013e0f03-e1e4-4f97-a5cc-e6504f684620/0c0ea6a0c124d87027d8ff6abeb7b697/dotnet-runtime-9.0.0-osx-arm64.tar.gz";
        hash = "sha512-ZsSHri9fwk1bqv37QobiNzdmS9PvwYGrwxz13tYNwi5LoXkXRKUG2jQ+YDSx/Not7nYdnnEimUWhd7dQi6bdtg==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/4be484a1-a095-48cf-8407-cae1d3dcc944/9f373dc1d85022e004df3ac1071ace59/dotnet-runtime-9.0.0-osx-x64.tar.gz";
        hash = "sha512-Hr1ql6t0T+dSBoY51naxRZYNggUBx5J1FARQfo2CzZJo1+I5xDf53nOwgUHDtpO7JO6zzzuvMOO/M7Rgu5XUsA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.101";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/fa0fa6b6-8db2-441e-a393-2dd2f5c841b9/19b664790a03e20ce4069449eaa74b21/dotnet-sdk-9.0.101-linux-arm.tar.gz";
        hash = "sha512-zfiYnQLkpqoh5oCB6VYxjJTGAVg6dX1etDORnr5/pRjyB6oPWKCe4oz5X0RcSGOGwineaYkUM6SikUXvWWqhpA==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/93a7156d-01ef-40a1-b6e9-bbe7602f7e8b/3c93e90c63b494972c44f073e15bfc26/dotnet-sdk-9.0.101-linux-arm64.tar.gz";
        hash = "sha512-xfnBfd7VEBy0tlrRAzrk2C/FsEMDvc5OthptxH76hCAr1ybQXK8RflNqAb14rXc7jSPL9DvGVeXrmRKxIHjgsQ==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d74fd2dd-3384-4952-924b-f5d492326e35/e91d8295d4cbe82ba3501e411d78c9b8/dotnet-sdk-9.0.101-linux-x64.tar.gz";
        hash = "sha512-kbN+/WQkLl8fPCAl0YPrNOF/OpJxxWAvKd33lIRe7hA3I++VXthpeI6/WnMejdxpMoeZySxkyxGOEyjSWaatAQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5528c94e-1708-4291-917f-c9b693df3389/b851b22328c11e88f9fb61ea3e18582f/dotnet-sdk-9.0.101-linux-musl-arm.tar.gz";
        hash = "sha512-fmVg5puDueZJYekRVfhYVCHDos52iXhx04ZJLGI+koD2byKE3Ek2K8OHOeSBclI85UsiaVJENzlOo+kIcooBGA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a8f1d5c7-c724-451c-8659-fe6ea4e72ea8/1c90dea91c1e117b96198bdccdc0b594/dotnet-sdk-9.0.101-linux-musl-arm64.tar.gz";
        hash = "sha512-am1qbW372stIN0wKyb2xyTeB85cMh3iwvuHxWaIrABdoaCZOYFMx/vgzy5/tgptP/UFCdtDRFAqLDiVxlcLzdA==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/73c11b94-0188-458f-b599-f7591718fc28/c44e21ffbf353b50ef88a76122e89e24/dotnet-sdk-9.0.101-linux-musl-x64.tar.gz";
        hash = "sha512-P04U+3tS37V7HjHLWXPm4KM49/Aw8SswgtO1XxL5WH3fSSanxfz4a3ZxOX5E+OXCD7lJ1w6afdDcJ75zpUjf/A==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/6707b71c-f95b-46b9-a4f8-067922291242/93d5be41bfa39461c47bae856a8ad93c/dotnet-sdk-9.0.101-osx-arm64.tar.gz";
        hash = "sha512-xmCO0oDlp2xGzo+bBrjHAUx721SpeVxFhd644FfbTVJAN+ToL5yvMkRO7eQnyctf27ciUI84nviahk8LuuR2ag==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/330381bd-72dc-47ba-b5fb-884bd8b0bb44/8f1eef9415fc29a806fbf80a54e28c0e/dotnet-sdk-9.0.101-osx-x64.tar.gz";
        hash = "sha512-DBPjCBNI3SvPLgxrhLw3X4BlUPbDibH8phdnrWuQBDAK9yct4Zk1jzKv7ylVE7pexD9fhhTRJDe7iEvo7KTeAQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk_9_0 = sdk_9_0_1xx;
}
