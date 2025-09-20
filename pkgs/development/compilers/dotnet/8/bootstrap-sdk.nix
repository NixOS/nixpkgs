{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.19";
      hash = "sha512-P0MXwA3k7np2YGyPmYZSWIICTCwzGGka350Xqa+EucRAn9aoyurrm+ZjCJKzA+N9gRc9BaFLaE8p4vLDzQJSww==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.19";
      hash = "sha512-VhKbsaln9sfOfDvxFh3eVnIQEZhfPnXG9bV9N+unU1GqcZ/CaTSfe1ASAJ230LtMlrtxNk3EqUgSQGX0TQITLQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.19";
      hash = "sha512-qtdfpsuFFEQx+26ZUv/95fSUYSpZ6r2Ch0vFKgIwnnwtEOEw7B6h8D8t9P1XkYn6tJvHTdSC0ohcOk+HwELU0Q==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.19";
      hash = "sha512-PMYSj+WRBCmeERhq7w+qzqCDAKNR5t2EAMv5w+TFzehtfqQQR8rKZDpYAmzYFaWl6Rn1wOZmjHqsaGbvoL+eMg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.19";
      hash = "sha512-42gDcb3t2l6sjYOGsDtZiR/PuY99Ctj0UnUgY+BeavYXqM2huKLa+r0Yg8YRJLkLeWF/MT3KXRReUE5Dnu0daw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.19";
      hash = "sha512-lvC9ihhOhbjbAwG90fnb6BIHnB/kz3HDz+9JSTaoBIyd+XBnckIWdtDxPtroWrvoWqydk0TPYxPXNGDY+I4E3A==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.19";
      hash = "sha512-oADBsA42EoW8MmpuTl5e5TrNZSNtlpOPsSWtY/dmVdK7EJf1QAQdvHAxZQ6IGDNsKrI4h0VEo+75Grmmc41RTQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.19";
      hash = "sha512-GoPqp8InCwdG8uqW1M5KOqlBHyYLFRuHRQxhBKNJCVwv+EIkCbVkxE+SzLYQaqMZZGOl86WFBLDMdTq0d9+Tag==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.19";
        hash = "sha512-CBq+wJbsMgLVJJLS7vDyefSpH4f5VT0+m80rmB/XtwiFNe8oQJHs3bRpSef+JnKCJoU62ijGs8IQMFsXYbraYQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.19";
        hash = "sha512-jTF36xYRwLtBq67lUy2IBUZzsRK6nTQuduGtaaWUqO6YcTb15SzN17MeJWanD1nEeleKWR1AL1GJb2cAsEnUiQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-EryMsQIZXDc3NLdZ2c14LV7XxkTtIJrF2e4uVE8Ycvqo6PiBZdUiuNEe5HI/wsMyOx5TJJWVW8M5bvykSFNUpQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.19";
        hash = "sha512-ovKKlV/bfPMcOX2NIr7QXZwZceFSqFwwzLdYNZI1sm9WsXuc3oYrwUoWwcyjXobAQGo1pY1QW6l2eU6TFIDBVA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-YuSYCslUdV+10cBI5q3oIxVPFWeQPXMAnkdKpZtOFNCPy+1I11cali6yKe++Dq1LeYAhviLbYnnL+1nFPP9jPA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.19";
        hash = "sha512-KHOxnCTTVWjYhItEHUi437lfjTz7GJDN7UjUILN1qe0q1i0kFA+2HdQwKt/SKBdF9iMJiDS/XotD+EOYbWSS6g==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.19";
        hash = "sha512-cDvawzOkUtG+BMHhqrwAu3F0AZIXoeMOMAx43x5zH1XerKAGh09ggu53jnIByHmYHI2F9Wze2fSwcmNm2akkgg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-X4Ku+V3mehusrwoGqQ6PSoWfvCe5cMepsoKG3JSylJsd6CL2MzMBQa6CZU8ByB29JE/dwOo7MmYbNsxdDACq3Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.19";
        hash = "sha512-MnPFQfcebuYBLfIxKrzO/z6fNGhUpm8JMtDkoX9zm/OitWkHBpYhPANnz4baao8t/X6xvLY4jgURXurqt8VWIw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-eGiP0kagfsqjLFYuW21kAriFJ0EdThyCpPoB1657p24cg4Xhd2Yeh97FU9pb0UAZA4zqjhqcCmqWvcAbyx5Oig==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.19";
        hash = "sha512-pBo4JhEGeCG627NFpSO7+KJgh/DPcjuz/bEgZ6dRHXZI/bDmyjLTGJQvyvonW7jhgbxgBbo2WayHCrgHFA74Zg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-0+1JQFBD8qKmK1j+5VyY/5fLUU5lKt3oKLqDnIE0KZlJc9uJSi174JsEqF6rjrEtWRPXSaDd5QuwCUzeEuKd2A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.19";
        hash = "sha512-dBj8Xuk6EbKF/UdeP7e40ULe1XDBTBy4W2EzYBJoaZ8+Qi9LY9PbsEfrXEc94/o0cBM6vPiBNahEpJcS+ao1iw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-Jfu88czW2sKACGPJ/yMV6UEiPUI8yiodPd24p6LAPRUCX6CI7UbEc30cCAmkN9TuEt/zAK4dKG2hs3isfdjpNA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.19";
        hash = "sha512-UjZI9mQLY4k8jwdq9NgyzfPwWxDmEiT2ahqV8a9AXa33AUKhXr1X4aW22e5QSUZF997psI0HI4DAYgnRrZN6vQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-MV6poe/eVPrbO3CQvQNn3RNIymVBNWJ7updS3aSZVhlL9IZUuw0Oyn92pi8Fd3qOWvZQcdireVua0AWBmD14Hg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.19";
        hash = "sha512-AQJC7awIrQnM6TIj1ZrWaRc3HveorRrQaGxfCd4Gdn/RFJXkiETDSUZuakkHLmND1HUcBWZ003UlJasJoDe57A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.19";
        hash = "sha512-zkLC9ydX+0bsZWrJxWsWM/8LPujWC7Z0L6QHdYehClKa4Lrk3glBex2O5q2QirqLjCFDjYRMw7KSyO4CUGv5ng==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.19";
        hash = "sha512-ECYlGtxCIAHIMQRTjTrrAG6O+iTP+2LV8g02ttgII6BPw7fpsViPtYpgXAKMx2SW3NjlS9ePxXS+LsDmJ6peKA==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.19";
        hash = "sha512-CXwG/jLFrC1njHjZnwI0cDjd7Q1CQPGAn0HFM9BekI3xJb3MtlfPyyx0jN7NMsejToWeXgw6wlQ7rLCxwcGREg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.19";
        hash = "sha512-He223oJT1MMpZKYApV4yb8KFrP4x1Ei+Z2ovHubJ9IYJxApvw17R8GfCVWYDwQiUITd5xxfXQZAvq9Uhzrdumw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.19";
        hash = "sha512-Bb8wAYk8zTCXwd25mOhVQg/wXQrRxQplxD0t189tfRox90zE4QSWPljMR61AAeuFvnAmFHX2/WJtYXq3tjSrRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-kaSQrToRQW4cNifw0bHzfFt8bXJb0bxYYXzOm6sKdw+MAMO5fIIybr3DpLSGLmqqz/B63Jz22Fx6OoVFw7G+tQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-XNqp2Kf81OCORVhDCLUUVIyQWmnTW+xqdeKcv1/DWUwE0Bs5jzhpk/LmE0yRoduTpXAyYkPRWpxWZGOVa2twVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-91csMX2qwGariQVFLhCOX6sRywEuX+qoOht0GgjmqmaKI2JxEleCJEMcJ+n7RqieSia2txmVzeHYDED3+5xlKQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-fivtZRiA9IH/8JqTnXxVfQ4cak3hnte3tZLgPQ4z47/xAxcvz1nRjHRbblIl3FEfGvj3oHJakbgttSvvwdrI3g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.19";
        hash = "sha512-gP/Qk9rYTT7upplXUbUmhMnxUC8KcJWZ3dLFdW0zQ78zxkfkIDbJ60HQQetEohnhUbOCX+/j2N/oEzeLrESGFw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.19";
        hash = "sha512-RZ4+PXfM587j+4jVt5fMFvx3qy1OkR1q4Ztj7LekJBCidfkNcmHI64sVm+ev1nS1xhBQNgdCLRFa8VUqqPSgFw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.19";
        hash = "sha512-Y3BL9qgrcCZBZVlM3anKLX8F2atrzvCm4gxED1hTxJGQyCp24xEaGKa6BRfq5NdQO4sKOS3UWDM/XB6qr4yx+A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.19";
        hash = "sha512-29KXiTrQ5adugytgWnZfdBSyBQHvlPwuClP4RyR0DRERHfMFWfZc+IFYCvqr1LLquPBR2Ev/xO4SgOfgQyu9kQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-ppU9Qz/PQ6ilQze2Ep7iG7KCzjMMWnd/JxY0c7oYeJfT9yTjBZOZeu4CHM8Vi0qewih1fI521CsIbvBKLHndSA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-jIThUl9XLKaVo+bTUtNzO03JAvmP/mc8Tqcc9xSCvf9TzroV/MrapKju/iN+zNFeS5OnJIF3doKEbYnKnCWs7g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-zQlXKZ7Lcmy5iGGIFj1dGAdAGysgJm0r67quupe3tlBxHvi17Pntb+zesPSp31kaX+gqLdVWLylBLnb2EF41bg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-XuYUWuqO1rOCKgU0T0OHgjdlYg1xYzZC/LnIoM1UBV+RiByUVCDlNmctSNlNm9nNOHVDxrDGMJmjG0LH2/66dg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.19";
        hash = "sha512-+tKz3/AS0uatyMFciALifG0HF25uRxYOGfMZy8FIg2xrkjW1xDKg/Aqk2kHu5K+yxpO3ez8yutqG7AZjGO2bAw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.19";
        hash = "sha512-OVA3+spWeTytk2DCo9syBHUmc0K0Yqyh+AvULvV9S4rAsdmgjKDARVNYcImDhMqRTTzX5r4uczoWnBN7wPqEtg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.19";
        hash = "sha512-A3KMblUwJ9Zezrr/lX753sK8JamQbN8T7W/c73PXXlnikdvGSDJh78VtyMAeMPfYlwJQlunSAK0GmYBTaT6hnA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.19";
        hash = "sha512-vKT8qP8s2Q+Eef3gvp8dBhqAmspLUjrc5EpfGBuy8ALUhZhKCZUXPuvwx5QjkPTcOb1hOUmEcOAenQ+WEbvnFQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-6OEEohAtoOS4ep+vSrKXi8/Vu4jIRD8woZkwh3Tt0QtT8xV1tmWeNH2jCr76sP3FbIJaVZ6NHQRkrZfov9yxig==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-GLxAezIXi563N2/q3n8KRxYuhcJaLGJth1gd+G+sQJw6uEv51YPP6s7DsBgewF6VyXDDnesLTGnkv8fkPyWPKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-H7e34VBAQ8P9afWKyKn8u2FMGkx6SPqwxk59KvvJNXGE1tt64Y1xcjtoKWU7yY/xgRNyW/7BxBjyjGs96HG9BA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-MaZramDW2KIdn5sn5IaHGpdr9AvLbBwh6TNzDb8GyzJX1BXzy0QIQPBGM95uiZ7bPZXovgvM/P2myS3aChOX+g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.19";
        hash = "sha512-Elc+6ExneINHtEnt4Iq5M9s3t0HEJN0dqPaWMHsag5dzGi6Qx69XboScBNWQhRTKMxoKYihPOL3pk5t4Df5rOw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.19";
        hash = "sha512-vl83UEXMS2sVQ5vPRPAr/KX/6gqA3VxVuuzdN4rAo/d1dFK6cFyMLVubcCxIYxSIetaLXLagjWxwKT7TE/E6Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.19";
        hash = "sha512-qt3IKRfsRC01XEGZYcMK2Na4Ji9J8BFoLTccxVweCNiWxr5QYCTXuAlSCtXPaYtxM0W257peDibq5GIVD2afzQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.19";
        hash = "sha512-GfV9610N8O7/5aKSauBTA96FAk64ukA3tCZXRjwZrFM3OENfZV2T8NsVSC34lslpaotKxUC7nmQp0ey5nzaPYw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-3z1K3i+s6eyJ0/8OXrW3J6n4pIDv2bQ0pptDpqUuPv1ghiw5BJiF9Vmm1xxhi+HLZkc0wz9Qfg4OAoAyiYE7xA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-W39Zdgq9WUqwd0jY68BWcl9ufhSWtDYwoZB+VAkNauBs0r5yetHsvnkXJAQPli7/d7EVLfhpqhQb+KKcJdFpRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-kRSdI5ex95sqFc2DBQ9sddp0cRLAdy150AFVdK1LbwyoYceP9OrEgp2gImAC2nvsFPh/ol8XioV4SHwPss1haA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-bTvHoP75ZewPL2+dt0fdwKBgEGxZxyQLLc4KspJ2z728QXBtAdvdjoMoHwbOyC//oApzcB68v7jP5ADmfzk5Rw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.19";
        hash = "sha512-bBiA+tLA5pZOrtC4u9KhUlh8mcXFMZoUmGLDII4Iu5uJxWoq2tox70OHOgjwbHF83Q5600xAX/lJ4cNw9WVIJg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.19";
        hash = "sha512-rTUR6aubOfJFQOnmWuYhhzWQfT2SgnMXNglHXNTk9uod+C+P20ZaiJGU0YUObsNhi52MeTObNXPorBBqk5yKqQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.19";
        hash = "sha512-s4W4o/3xrWkMYmpYeRVk/POlelIZ1XuHvVFhC760mVp8jN1zvyhJ5anAR2DKBOP8RhrMRQAyvv6g+5yYG/b1HQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-nFTMBMKK0daVxvMxE0ORujxVBRSbdfBDZ9em4i4rbipCjmy9tFMbyzTccG3HykaG5X8czARrWs2zZMMRjwnNRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-Jvzq5CmlYbc31/jf36++T/7PLMzkD5PemLeIM9i1lo8R53yRT8CjoyJhJ1GXWrdRCdwEqbGU2LDDCp10lWSyhw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-ZEiEHIQnRNuCJpyuUqtIDgS+m6ZtlHSuDwqxdnEUV8RQtsgcLGF4kMnr7sfw/BjjRqLwf79lcRCiOFWVrwiiZQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-pdJKTqFZEnWjO7YX3c1FU+gGB4/l+tILT5cDzRUUxf3hkUT8FeWzxcYLUySWk1MyoQcHLbyLvR1rygGbOf2y0w==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.19";
        hash = "sha512-+I52qNaW8BZAbCUO26826ZCHUjXB7OXdMbS+bAOOv3gt/yAZ3NiN7RSj7BhO3yfQdam5YBbuj0cBiqdrayJhNA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.19";
        hash = "sha512-dV/b0WViiujT19HQwz6fLKUB/orjGRJudQIQFmHM1Q/0mJ2Hr8GK103ZMpXHHGH+Fl/TqSCQzu8t/U0F9q3+Kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.19";
        hash = "sha512-S9oXhzzMHc7eNO+f6qwEDddpBzzeTqtasZ+HpSFPkCQwolaJ+FMe+YoDDvsvsyzr55rCIhjl1HlhzMyv18TFtg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-PwRDoFO8M8OPF6RzJfXYamSsXKCNqbZBS075eSp7b/+gGusjVHZ0ZAcVpLCQJWQmcR0AVx5g0VfN+Yu9F7NDvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-9OHIz+fXQuYSL90LYJaPctGzan90FFiwJRDCTA4Zc32vDaXagKtJ/QCiTnqomCsyo7JZDLTkKdasArGfvdbZRw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-VcehwYA/43AmPo9udZYDx6UMQXxI5hMh0h9gKK8qrdT9B0dJaVfdlKvlAs6uN/wGQId6ggVRJbRUZnKLpdoDsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-g/LtDzB8jRYARNCN2q878xlDIeuRifUl3kSucaLoh30Z3cngd6+Aej3+cpZYMgM7jz+llfow0Bn4OJWvt1gqpQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.19";
        hash = "sha512-k0G2wrG2HHgC9p3BlePoshY+dhCtTHIvwaOd10DP0Uxanc2p1A1DAiekzJJPyigijzNXVX485Dp+muCPcfOjhA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.19";
        hash = "sha512-KUPz6ft9EX6olnkY4hJESg7vX00GBD8VF9J5d1kV7E50sUNAT1csl69MzINcdtFHoc5DXF+rEB6lVGH05h1u9w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.19";
        hash = "sha512-+x0kVdmffJet7+YuFHKcREPMBV37bx7e4kfAjbD+5/+dA5KyAffcrQore4+gp8y9GY5q/lxgHpLdT9YF4X8ZVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.19";
        hash = "sha512-v+Q43E/2RVECjIjyU/yIaKAdK2ipwf9iJ95LlFtBVaIxev+/CuFI6qiZ7TPWmh6ZmdlilqNdqFQj7qngTZG+fw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-FjuQE98YBxVTdMqhMN6ciE8af/J6EwkpW4XYC7vcJz53gSWJvB416C9Bs/1R09hP7Mua3lxTCzhKfnxWUmxCCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-fWdoxak72kgmdK/e31YPvADhoFXjIOuUTe5BfhNr+oXFX6jCGxttf3L/W3NKzMntuHqpy303d3IrtgICJu75EA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-P1RHomV7Ei5h31DTIQOtUNMq/CziuWdfjmtU9ykBOWyWBH3aCl1K3jDm2hUs88C8Cb7NuOP0FI6So59ic8lhmQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-olOQVkYIeCv0FFYfrV9IfFJVLAnhjk1T/HDIRiNnyJ7JH8HFVytxAx8hQaIPL5xLGQquM/mxPlAoH0Tm2+k6XA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.19";
        hash = "sha512-4tRtmqt7/dUFo5EUzDwZ7CWYn3mOXbLO8+kQ23+CwPaTmkisNhOVX8oAAG6U2LZ2lCms6bFz0SI/C9zSMd+2Xw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.19";
        hash = "sha512-Q5PYdYTILXVSPTTXfKn+O8IvUH7kxY1YHc+Xl3r2aIUS7cAbKaWAV2S2WGUwlrC64E+ECyApC8hkJo8z7VOjHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.19";
        hash = "sha512-2vg1H2cjXAZAiFqhuej6VRDPyFuiye5t6T4wdtCtQtE/xQYY2T2CgU1ibeLEFusezKhPYLHV5lJn040UevXhpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.19";
        hash = "sha512-Ci70ENA+3UZOxnQWgPUXuAuiWX9vtQVewQjkgds9plKsZTz9d1YsIsJcZy6yHeoOsJshiWmOfmTI2BlXtUsRIA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-aA/2lxsdfu47/Jy97k0WO3jbA/8TCtc4eXli0zlHw9g3WFE7PcHlw52nLoY8nvTh6baB98f0mNE7nHqyWQ58mQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-L0EG4UgRxbfDAXXMBIOCGt6MFCjEvasR0xUkriJZgK4YBldO47mePbesFxSGVCAtz0+t0hH2JNPZXBpKPajjBQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-MKWcwNJiO1e0fBQVHcJWnAYwwLqe78HtaCrWr9Bhe00bTeZb38+e/59tW68O+W81RbGJ9teBuUWHnk8MGQsTuQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-QLYgv1LYdehkZ64BaCQ/tAjhPdGDHEq4TmLY9Afh3Hi18UNZ43HldL5v3bJ8rHsScoRf6mNCOjtiahBU1ziPVg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.19";
        hash = "sha512-cesMCMuSgKdhTe0G1Ix+RJ0dzrZa0r7SYsH6uQSXIR9zbSlyqs9EhqSP4GWoF8YuBc76AxYTSOuXp2hwqkmHCA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.19";
        hash = "sha512-C/MtxBxoEnhHwQUdz776+FBVSuJgxqcaVp9IqoXjsE6axAq5M4opbs0DeaMyeiSCbHcsiihCDjnLnFb3uSVCVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.19";
        hash = "sha512-K8JWBy0ampzz8lsHMAnnZY1m74C2aVQ8QTi77rQZpDFmDxXDwgvW8FArmRyN1eJC8cO0B/XKK+Ytwug0EqTTwA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.19";
        hash = "sha512-y7SMliDR8ePTMmVj/VJWYI5R6kXeUuZDPfhyF0E7m+FzXaSbe7OgLGJbslkeoglZbyQ+GFPBeE/HqvHZwfrOMA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-QEQSSsQ9tijRXHU6Xe1z4Xm+nLP0xSyG0pm4QV4IyNGCZGRYJ2B1WDKRRUR2yddaiZ4ic5ZyDFdUFFx7oHpzkQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-4pRwedZaoa+WHS87F9xWVbOGLXnOAHMjgUhApg2rqAjXFmPNbgNJsXNe79WRin5b8F0A9RH7WqwCW0dC1MgJVA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-XTk+WJsxDOqUeAe6PLTNEPohOURWpufLTtnoLAB7jey4yRTs4BN1RVHB1fzb2JVYt0ZrmAGhFl65U2HP8freow==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-HJm2e3BmQp1AmtazVr5GgRn3JDnvG/3Wy0b8PE3zToMKJ/ibUrjpmdxsCPjn1ZCJLTTwGf4rJGVj7ivivNBgkw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.19";
        hash = "sha512-CW2COJrFqYMeWd7hkNXlE3X05+9wEsxmAjW7oeGaU9FimgB9ksCOv9mqsf5Cu4IPDYHwQOuazvd63+89UjFBXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.19";
        hash = "sha512-3xbWEAv/E2aKa+0x6LIVsDFnjuLzyU5H/2ozDW8+nnA/JPdI1YWTTM5naxdIyWzRuGmxowfoUKd2aA2+qtt0Zw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.19";
        hash = "sha512-E/C4I96r86EjKqW2Tn2zN8390oSymQei/YhXg9QK7x2kBwuwCs5gTHaApUXxRp4d6BqqUaX7GNZesKq1FLqxNQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-pGUh9N4I8QFfZ40Rmlyed7ATMT1boIYM+dLNdqhJPttttQzmv5gbFb0ed6sz7HvCYcfJTFWv32F8lTcLjp92GQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-qAMK+KMMJqvY0U8L3knVx1zFK6G6nLvr7Pes2LGQQ5o/WXHGEIzju9Ga65NeF4thn/teXx+Cm2l41/QxiyJARg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-Uu8uktFHgeD0K2HblQxoSpW9QXL/1QT1IDNQ9PTPQ0+qHUkASxpVmW22Q/OuLqjmhLoDuTwBQbzHTt1726hXow==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-Ai4Ufjt0Ax7HrQE8JtH7Y/zT4yas0XukRWRDBUrsuCIyddx4gm5u1lNCOZvJFIDerEacnWoRiUFW6CaKVlw1gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.19";
        hash = "sha512-u9qb/jJRjGTjkFRkSKQC9hfnK7IHDmP/PCbhYF7PiJH8/XlSpKcM5fhfZ68UxEuOnRpwTJNXxLISqgjffDorAQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.19";
        hash = "sha512-aqqj3wMguPyHC9A+Za59KfhfKqKTZrX0b8YI5p2oQME6KL6FnUqnOBtMWA+EqVRmpnstuWbNQr7fYEZ6AkfZWw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.19";
        hash = "sha512-4hGpGg8mphHFlJ/Z9q1VBUucrTrayVz8yf7Q01nheO3TIeJzR6oBif2CiiBggZWGjyze5om29FWUes3dku2Ddg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.19";
        hash = "sha512-M3DsPVjB/r8D0jQzJdPq0TetSSc1TbafVfzRMNfdzeXH8tLEjoW+f7X+/H8pRpFifnf1je/ZudShNx43EcStdA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.19";
        hash = "sha512-CV648uVcnDWldJRlFFi8Ew2nvp5KnJnnQEfPUoQKFATFHkAQbUIRNovRHfaNawXWGmKKn4/nzxKH+0lxs+VdBg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.19";
        hash = "sha512-qGcn373HrhZLCxZf/hLlG/OgrmZ5XZkh2mzVci5IPsp8jzqimStPcI4M7jgpYXfAkP3KJ1DsgtcqnSSHxz1Q8A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.19";
        hash = "sha512-BzT/17Ig4SqQIvkK42a3BcCQZMupZbtPTHBTdQn3qpgeZjXMiqxIxlbmrVqQcAMgFDo3EJlevy5hcDTLHd6YAQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.19";
        hash = "sha512-X2QLkgVo+ECd4ToqoXJs252UvB0gLF/pVzIADzczVmwnnZ3xw3QscvkEBQxTJRxfzH8y2n5BTJ7WXKVHPs6Gpw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.19";
        hash = "sha512-h422hRX55IIMQzTpHJXsKHWYTjmQhnu9SqH5etR8RToZpL9nIHXo0dWpl3bmsBpfKPhy+UUXU0OaR8OSbgzETA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.19";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.19";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-arm.tar.gz";
        hash = "sha512-a0r+fc5qsucGLLSFxGEm3OnP2wADch4NiIbM+qmm3uw+66+KTeaevklGOUDGyO9a3cRRLZwiY9gXELk09BuR6A==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-arm64.tar.gz";
        hash = "sha512-zBRQPlwdlKMz/YBI9ih2D23ysqzU4NXvRly7/ME1F3U9b9Wx1f5LOLB3BEGKcT4TOABUU6fLuPs/MAdg0A/G5g==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-x64.tar.gz";
        hash = "sha512-lQP+hGJ3Fsud8CxkjjSXHG7E1EaG8hO8b2vXS8VP+0HvJy+9LIqj8KMJsgZkeWwS+cd7E3AV+EWBrCZa8vIWhw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-musl-arm.tar.gz";
        hash = "sha512-fOY8CoBCDB7T+ylYy0oj10/yXvzvCmeP93H4LDU5ySg/1txVQDoKtMlcuigGp24MjXhkvr6Y2JFP773u+XBJJg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-musl-arm64.tar.gz";
        hash = "sha512-TGVuirBIgvdMkfeTEXTwg7Ju2QR4vPyQmEsXg9T8pr6x0CHsBEafrmEOuwLfc/v6WK898ejVLL9eBoy/NBiNIQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-linux-musl-x64.tar.gz";
        hash = "sha512-7YmdUku5ok0MPK/e1tD0bsYghX89i0Oq8In+hgb6hsJehdksX+6aAW1Bp13XbDA+LtwtM5PA603DhsWuNjTCLw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-osx-arm64.tar.gz";
        hash = "sha512-Dd8cdJjFKLIJgmOz0wr67QtARqorQ9XHqDdAOh5VgzXBqViqhZtJjdKiU6851B8YHLJpqukc2N0QO2SgYJ+YQQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.19/aspnetcore-runtime-8.0.19-osx-x64.tar.gz";
        hash = "sha512-msIOtqYmFd+4LFZXwRWHtiHz5/DHxt0xEd8GFIIJLWPBy1T9Ka2w/kOljGPrLKitMi98cixuR7JLeDhf65PqRQ==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.19";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-arm.tar.gz";
        hash = "sha512-sqsF9qKc/yuEQCEbxZGvCTD7Hp0IKxgLleYbfU4bP3n9KnKbKbqrcRSHgNksZGGOz4xWqM86ymIq+yn0h3Adgg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-arm64.tar.gz";
        hash = "sha512-E/VgfaousPmg+2o2GT0oq8lFQgivVXPai8X+9cvrcLGH3q2valKz1G/cxZyFZ9t3wpN3XP12pD6B/5nEtCUFjA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-x64.tar.gz";
        hash = "sha512-D2buVk/JqGuOrlQD9DGvWVZeYvXrWfblA3fnLFitJFUts7cuz9gkuFCkI0+u2yE5g7icxHk3L8Q2pVP7CGu5qA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-musl-arm.tar.gz";
        hash = "sha512-PVaVISyjZ0XjqelPUn0krVhdOL6hcfectHIl/wEEx8b4KBXDFpg+Er5UJquSsmB1XTtE3hRHxqsiVjJuhWFyEw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-musl-arm64.tar.gz";
        hash = "sha512-iOLYHKbsUtB/5xA3LQZPKjCJVzXHZNLZrcFI5OR//Iqjd2EDKZfvfTF8KevKvdqcoKmd0fpfF7nslrxtNKiGOw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-linux-musl-x64.tar.gz";
        hash = "sha512-NvvF7er4ec5DBE4eEAAgfyKfLxK+5MNSETBHaYAJHIMqdBDc9fN3neITSYeu3C+j94R9v5oxPWJ/IJS/vNMqFg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-osx-arm64.tar.gz";
        hash = "sha512-FLRqUrgqF5zF0Sk/S8CWgFFHHw5is341Jaj3QR0pkP4Gds4OF/5QsrJIgA7rPRvZvYO+w6UntnDYJeGkxD6Pjg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.19/dotnet-runtime-8.0.19-osx-x64.tar.gz";
        hash = "sha512-utNVjAqIbe35M+ZUKue0G3BhI26hRBcLOeD76bYVunbZ8GVt3Rub6J75MviU7enhtQMC7Qk+oNigDwSuYTZLyw==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.119";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-arm.tar.gz";
        hash = "sha512-XlKdFdSfvXbJiMSL4zKr5ALd1UJClUJAwvHLYkZSd1kujMdjTxnNseQgBYLKd3ogu3Yc+PyYRV5aupzp440TjQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-arm64.tar.gz";
        hash = "sha512-y6QVS1UcGCsRhc34mlb/UrtGoTXzS99kGrE0DeqyPubQ8kwHDwt6WuIBBdcdwxURfyit4v+jLCJCvbLpyCUszQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-x64.tar.gz";
        hash = "sha512-L/7DOAoqwj6AHHx1B7OWL/0jKRGtBgJLdLl92stvRoBNj2MZ60x/x7Al9xZ3fUcRAhnK7rwwo7H+kiMGb/ioyg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-musl-arm.tar.gz";
        hash = "sha512-XVXCZxX9srBQJE4TZeW3FZ0gbLTsvgXUDxbjtYbVp/vbSQQSr3IXF77mHuF8FtcJyOUY3TywxRxtEcKQp2mgrg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-musl-arm64.tar.gz";
        hash = "sha512-JV5KFwlIKBYCHLwrn7cC3BG9nueksa6M3YnbV202M5moD2Fvftq2RXerNNwGf2BezyR2BuQX26TjxkjrtOppSQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-linux-musl-x64.tar.gz";
        hash = "sha512-HO040qC2vVYJdccMiHBotk4JyAUjlZFk/wXw2VaUqbe+c/jrAt7LknGDLpIEtEZkNOo+LIiqujufyshTgzbUzw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-osx-arm64.tar.gz";
        hash = "sha512-NNERmqe/mqzEJgaZOu8C0pD13B5snm2aTbCb9JIRe9HX4V1Qt7hp8AlUzUqpfol6HoXvRe9S79TtLoLdKAnpgA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.119/dotnet-sdk-8.0.119-osx-x64.tar.gz";
        hash = "sha512-A9H6KOJDmrTSCoFRjdOWOSlS80A4AzXQ9i8JRWDmoiQx1Gn0UDd0CtuAfXwCT0KAcJ+XXgUUBrR2nfIlGoHd+A==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
