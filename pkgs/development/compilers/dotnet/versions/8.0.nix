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
      version = "8.0.18";
      hash = "sha512-cl1DhWFUTOA8O139k5ytpW4ttBJRSllzfpQ/sOXHg+r0ZYm2HZu4M4iMA70yHnqp0GtuGxqUBJ2duJkk4ydRWw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.18";
      hash = "sha512-rMa3+s+Qy5BhAw+Zj8tDaNtcbMJcn/L6SGQ/4/qMca+JxTdWUruzCscAgA35wNLOKJ806A0rw26rhV7FdZFK0A==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.18";
      hash = "sha512-pkMF8rdmxdni+bMP8A5kek1ig+rBriWqCszuNdH4MddjIzjQe1jNqjB0XdRtHZdKgL5OpWBK1nBPBYiT1oeYAw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.18";
      hash = "sha512-0HyBUjT2SHH9SrJxfVzsjb4wJ/3HJ2NZDfxqMfoDCRlPUCT6iApy0O+PnhAtFqyfvB+wpNsQmFhHi7MHz+hFfw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.18";
      hash = "sha512-WeYxJHGMgva5F9l2oo3N3+tKZIBZNoOCjyyXju8uyWnwxtbF8HbxbRZGxR80DVJ5PIUW8E6qKVo9t/rm+0gCIA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.18";
      hash = "sha512-iUKTKzPeh/7Vv7it/Jr7U5lCpfE2aq1hvtfdh9C0fBPboV+0fMG05t9dEl+ewN8W1rJ6+Xq92QEhbANQAA0Org==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.18";
      hash = "sha512-+6dNm86ZF+53JC3kMQhT1msw2CzoBijWMnDxD0VDsIp5lvvtNTWy/Sl5bTuvIFcSbq00iVefNHa05ELXs9mL+g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.18";
      hash = "sha512-E/HnHEgLQboNM63koeog+GQwoUjj9oLo/gJXKfdfLq8D9LfgG8tvkbnVdQD4zg9ri2pIGTTjNzwoy07whjGl5Q==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.18";
        hash = "sha512-diW7p7SmT+AaZ3w0mesbmnSLHLvcz7qV/PtstYS5lGoOFge9tqPrQKvN1lkjRTNyFxii3hpEVZYBA7341tCj4g==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.18";
        hash = "sha512-7RgDbnLuJdyhM8LdlmcSMnTuaSrzNCGe1P+SBMxfM8hioiwupoP1axEH1KkxCl0tWjG4EZCMpZUHrh+Gb6JowA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-BHJH9up/pokbEYBvkKih9QKnf/UmLXvX14m2lZZbVOvLgB6NR4Z+6ZOojuEJVmdFsWl7Ai//KYfc4sz1zewwAA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.18";
        hash = "sha512-Ymgqi3mVAYXktoV8Pm4uJk87tmoUsGNiDE6ixMghaSnrBzeJQHgiOgC08Loi5tt4GeAzKuofF9VWrST2Cr+mkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-JOnFBpCCSH6jp2wohLNBKeDXUfU/ZyF2Q8VALOqOh3oWicvO9WPw5skyHzuV6k/ClnKIhLZmJWF9sDIaCB1KXg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.18";
        hash = "sha512-fQNP3JTHUnEkHnXnRuH1UBs3SyTzf3pCoMA1stExgShCQ5tR4LKKGu9OdEG+2QdmJMdMSunnU3CL8/UbfU/4XA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.18";
        hash = "sha512-+F4XZgRh6v/UaQwU8iJ8JzHrhtWTLICXJ7lEv/PvqD37VQY/2irYLo4tCpZwLIfeZAldv4Sc+LeH5EcRov7Izg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-stToQ45BL6fOk6arYUcYiRF5gX244Bju/GS0UKJyYpf61SFVHgiOfZtqciFWWEGTc0xuEHURjvNij4FTTYYs2g==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.18";
        hash = "sha512-n4956y81CtgHtzxRlLoZs9no1NeT6vHtHh00RTHST7m55eMV2Tslm/5k0Jo1Xo/T+50QmZqlGSfTH4hLpwEh2Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-xFWpgrb2yEEo9TKsT7Xpoj1lHemgKVYHW8kyego2xES/aUl3Rb9IO4hEcC3aAVcCpBp4M7+NrfhQrqhq3nI5pw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.18";
        hash = "sha512-VsnN7b4GMKgq1FcJY7Pn8m3HWqdpZGjuAyUH9eIlvQGV6vzc9hvHIJhmDPA+hSvbjXshoa557IMWOJsGABo7sA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-AA1LHIUoiWZG3qg0mRh0pBhnm7eKygNRk//A2OUpqxpbdWk5TnD0s2vuYqwonqonW9ykaMpP+inmyCB0fpYvtA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.18";
        hash = "sha512-sm5LY+hvq9/nxI3lurUwr7fu/abqb0DAos2ItezewQEGT3A0mNY+ZzawaX/dTAAivl+eToCMLi+2rH+OrRR3gQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-3uhlEm4Q2OVGEjmcaW0m6BvM93TKaJ3UDs5Ilehn+y6ZIjTZCqG5Svs7QcXrBFDlJX109TtPV8pPB6eCE0O+6A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.18";
        hash = "sha512-3E91cZevql0JI3Gqvxr9Ek8v6Bz8X7+CERVhKioz20407oziovUgfQPjcpXZ4maXIYB3Rg4qo8Su97dJRfYlPQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-sbWou4XTgFm96/sKC6ICivQA2OUwjEHMdk3qhW3oR0HeFZNyGVfYgydgfmIhv+NPtxA9ymBtYT0Qy+Qzug5VXg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.18";
        hash = "sha512-ZZn4xQQamT5qjamOth5sIXjGQ93/1Q0zTMS5OdlmGEPQgnIXqscaGHa4+keV92x3ZkdYWiVfxVWJ388PS958FQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.18";
        hash = "sha512-laTLzCURbEEC+X+WfJNkDXfjk+s/9RExjWJ+qELrBw7ekhepQKFq7h5fVONVcRdI4GSkpG0bETwa6DXPhi4iIw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.18";
        hash = "sha512-6qw3f6QPWExHGdMEsw4s5DmtN8BLBXzsFMH7x+7hjdnZvfx1eebZdY610kYGz8Q/tcd0sLa1TXMcrF2CpxixNw==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.18";
        hash = "sha512-97IplAqXG0a6rE5XheNUd4Gaeutsoe0TtCg/rI0h4qrUbCOErcuf/w4OmoQMKPV8WQzIUejA35EziyaulL0/EQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.18";
        hash = "sha512-a9au+YLLDhwln5XPD0ryW0+L7cq/OZWlNaOSU6N5uwiL466rrJ3cevkOeACO6LBFmWCm9/mLzEY6XwUD+O85Gg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.18";
        hash = "sha512-DceneYsM3IeWIEZTAQWvpMhK9LUEWpse8gE14iyX1EHCmX5ZPyla2LFC4KPzo5sEFjfxxUXL1uH6P4wgegBa8Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-CddApCtn25IXLSFNGjqhNSNARB4mVJouJmXaIrdNdk2i6FlHQzt9ocRRNHQcCyds2vd7Xpevci2KcxA5ve+7kQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-/VBwWQ5g9ILmScK/BnUHc0+gwuKE/Hcwn4lrc88dywLo4d1mmgciFRAK9y9vjSqdK4LnSeDYoNV1Up64P9nlvA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-oFfmKhY4Xi0ulGkYMLkSQpx3tSX9aBG1vld2I4pSyN18mvkDATyWoaR1hH/xGNT8J1Zkq6X13ugCoJCeNc+jQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-Tcsp8Jlthe8wsFdO6Nn57uO5sbkYBa6qyrc2DSpC7k6pLbrGZ+PRZ5fnl+6iHpPCoABCAMvhvwu9CLSriRhJ9g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.18";
        hash = "sha512-8YTjgbM7KXUy8iGyatSNmhVDDaQx7tuHoHtO+LWOkusuh7XNdcBXl60P4ESUNRz/Vndhyp+fXE+S1dGgYuabJQ==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.18";
        hash = "sha512-LKWL8GaVV+r8yqsBx3PnqM8o8DwkdsXY78RVu812ii/roK/F3Tj3cAcBkjdX65jun3xDwCY5Sz+4PNfitGCHPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.18";
        hash = "sha512-L4qih+Oj2RQrRC1xivu9JwIFyktVZ9cYzeEPX8IH+qOnmXUW9KWTqvj6axLmCsibDpZQQktGvVSo87B/HeO0+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.18";
        hash = "sha512-uAvqaMX+UBsF6kcjSJsrDRWwQatSWoab6Zs57AEsgNBSImUJ469cWv9ByjJrUxqbcFiiJuOd0ERw1Zz2COhawg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-1NPmjQAfTKpcqdKCbP+lCv2oeltqjZsCIUi4bzffAqjgKMXQ9GVJwNTRVAF+IUW2t8se76Si8tnY1aPQVZ4rcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-t7s5+Z9f+HQaLEoH8dFKFsigURWEtbX/4DTVkbb61PcbsO0SqGO31V8zEoyzOtfddaifURFbFA42aODv6vqHcQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-Tw+xdAhQGksiV7p/CKP6A5ORVbxEvnfiZWPQ2YAMHIV6h8Dg280+U9PBv/yCtIRgPbdBWnc8EkwJS6J4/Gn2pA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-9lTB0xWTtaCf5dfxpSxqbMmA36UKhSV39ARu3jjxnQgHVBoHoS2z2k/LD7dkZOJA7Pdu+bxPJRHCDKg45CAmOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.18";
        hash = "sha512-6wPjZestzQO9qWYph3USKofrCRIEzRGIkPq2rjfObqCBFM7f288rVsaoomciMm/rzNk/IhJJUOakHyBna160Gg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.18";
        hash = "sha512-AK7WYWP8zt+AFyORdzikH5ZMjATQ/piP8B0+v/sHWa0qz+l7R7VT8xnVxadn709XeWHYtsB5B+6UQ15i8JrAqg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.18";
        hash = "sha512-DTOaAtQ/DKJvjBZCxlevKgBmI682/GyFgQ4mY3lZGTlwB5mSBm29zzj15ptdNpJkXwCaWZO/zmdz1UGxSaNIIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.18";
        hash = "sha512-B2b2WffuthV380wKbW45bXMng1/CFF1ZoCyvZif09VxmKLvYEl9QTyWRGXhih64sGXDnA5wZ91TuzIynaWLMzA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-6Xfg1UtpRheZIkRy/xBqkR7H50NAzE+Ww8cfUPCbHtfUDTM9MyCtmk2LTeIZQu0Fg1Dfr+esPWS4ieYTDufoNg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-uZWrqquGM0u30M+1cNjLEiEu6284pQ4qpRVNzQhP8JkwlC/lPlXmjcIkJkn8ruq7wfP1oENi1cx90W5xW5NPdA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-K/PztujikPjSxTGPYrtphyblzO5uk9Jt4oR1RpDcqWsKLH2jMQnKe1+HrD0XHXVIstqMOSwIdoGnxAsG0ft0sg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-IlY9MhVGjEcm0kZaetRqJUESID7eo3C1xzVz0kwrcrKJl3wGEBL/7K3BjgLej0UKTi47mIqxWA3vWe0i8JdnBw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.18";
        hash = "sha512-el5pvDgxwTJDJHTQXNtlU0umzSN60rn+e2LqjrCp52j8vXBjD8mC5qg4q8f/OddzWlUqIAZSe956fwZzRfhMeg==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.18";
        hash = "sha512-JMmBY2t+Lz5EalgDD12mE0k/VgoS+9oMfordQYMZIpKxiXvyFCbhAo03PqClCK9VvfJpw0Sr4O5G8vli1Wa+3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.18";
        hash = "sha512-GiLJOvS8t/Al3a3WxYBPbKMYBo0YYcfKPtQ8/TFBZMUct3yx20DsXhv1qX8OxxEDePOBNzSgbxRb7RKFvjOeIQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.18";
        hash = "sha512-yi6TOgXCO+6xR9knQR6Efqgku9pEyKG8LpVHLtCfW+pdZT2m/Pu0s3LTNVI1EV34c9vg0m0CfFvMlu8P01n0VA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-J24jZqdMfbwzk4nd8At+EefD/oilsu7umb0bicUA0WKY1qVVNUVGTvWnoO+bK/ZiPv4SFjYdn4gZARqUEQnorQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-DxjNTxOiG2FQgkEYUgZ2/HFMvLo8yclEUma89dpC4BSVn/7OFZldEvEkKKUDNhLJZMv8DUXb+6snXy/nAPYUfQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-c/4bi47f2sxg6FXsbVcfChfl/FHf7xN6mPUKqNIRReisvv67bt3utR6OgpX+PkbbdA9ojEfODVljSXQRrluQ/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-v+40oF6eORT0Z970gVunxVxIniO5IPg0ArlT/lt5E6rPLapmfauIT06v42Bzqf1JGYY/A4PCyEAlaSchGW6nEg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.18";
        hash = "sha512-Y6AHcXcoFbZ+ZNs6M/SnQieZHPd2I5isi9mviZ2svHqXsUi3GIC7wLHj+SrJpv27UpWVTJqcGoalEz1uNO7KYw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.18";
        hash = "sha512-eO5zIpPTMrTUtDF4jSRL+3///bPp8KD/j54Vyni3hE1N7GW/0vivulh8eRqSGA5u2JqXnlpjmRKhgmR3Qcl3Ag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.18";
        hash = "sha512-dExyzX2A3z937eyzaU246VKWCTNu7SvZtcS7rENtnJ/0xjQn+b9mtGYlr9QwmnlpYGME4gDwxiYNz0AH2oFC9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-PjOZbnpXMRehVGAo45UAl/svvu7JEdQ+RTN4bcvOohJ0mgUtZJxHijaLRFqegEkC/HLysPCMIRS+NdoySgdXPg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-cYSafamQCxV6XB7HeLpsnzQChF9USa+gVUwXZZGd+SC3vInvWA3WJ0E6CpgHPzn2zTrBmoDmPVaknQCNklRlrQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-nV5A+iQQX+vr0J9AJ5zf/sPXFi8T/zge2RLHwTiA8PhgPFrGSIqQN4Iu6l/xibmgOoKGOcN05Zx+4jD3FBc/+Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-0J8wYGosbk8+57fCrT4Oz4tWngsoTTooDiZg/SGMx1X4eR3tNRVbDfXSzXHwk5JwbCCAPMdk0zOPnAy7VqYFhg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.18";
        hash = "sha512-Y1BIY/IjQxEjj9xN9Ws3QXE+xwQTS9Ud7oyKqpxjgW5nYiFkzIBHntB9GTvIPsob4KalmgvspG8pbd32YcW2Lw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.18";
        hash = "sha512-Jc8N57Rarf5a/pojGgmTkzd8GoSUaBOnKJnrSTqYCizM2YoawM2Aps0tHvpRMG0s/u1NeXP5Zr64hJkVA4yLVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.18";
        hash = "sha512-5uEfyHLfmuox4HVbRjWk0aHmho+P9pLPqGwP314G34wC1JCSdQRynaOYO/B5Bo7zplC/dcn4lfqUsu2lcwwEoQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-cIK2i/pIgNaFwDroeEWob/Va+c7dhxF2jnIfedlKA9jIG3EJG2q0OngmF92olvJeEkso7xeC/SfhtE+CMGIbBg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-WQ4mXlESm0RzOi1fZYWA6r99Ohh5kfliawZ6MAi7fR27PkORbA7+HtysPzMG7fFYv+L5n1JrUwj8lKhJpbz/Bg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-erO4wuYmgpHtKJPr24sdYCRGvI0mkaghPhnqo7sPf2gdS4l1J53PMYyfsn7cwirpt2FLsItSXOA8FI38YpBfTQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-3kKyR0GwV5lxYI3I2H5P1FTdy7E/MXF1kzoPQpxSglQRxW1zG5ubmjFAXh2D8Mfw5MtUoyyzBc9Y+uvM/SAx5w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.18";
        hash = "sha512-s597lp1X9QNObLRiQ1R+w+4VqkB1ozc6emWQxAdfA6/Jbkr2HUkuj+R70k7E4lRCFXYJiEUeeAv6DLV034kxnQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.18";
        hash = "sha512-f9+1sbW1c9OFYLmtq+b2NuviSCVCEOCvFfVVJFEQ9kVg4aKVNwwnSqGHL39P8Y9Bo2j0lzCg9G46PXz8xeqrdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.18";
        hash = "sha512-R3ycWivxbGaOXJOrWFgdDhvancCf3xcj3c2x71LHxzAwemQ2g42fmPQdnSfJrW5mlJLkZPkr3Fcy8z1pAVHO7g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.18";
        hash = "sha512-nwpET4yJfVfBLZPPZTwXykwsGFmBIQeu2WhsnKSy51UMMua9RH7wdaThMhY9dHHyMeRniqji8wJElv6ykiuwPA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-NaT6sx3MV6BjcrbbqPrUSv0sbLCOTvc+qVlQzHjdplFVbm5kfcWRa61uNeUztrzQy10IdAerP5Rt5oU9S7Xm0A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-RD0S5aqsIpkOcsADZhG6TODKt104AyCh2gMzhXOwby8iMOQT+rj/PbZQP2fz7fOfuvcOe2VSSX/zoYQUfOqpzA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-fDJDwEJojp8D6mNMy9HCH3dytuXssFGa9eMFXf1j9zDkLKTdAIoHO9hzgkFNBxdZII61TEt01PrYVbEk6U0AJQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-C8u1lKK0f/pL325CR27DQXXOtCIc3p+6yctd/GbaJY+G1vJvVBWknKlBmGBTzJaO0GlNxWKBG4b+Hb+WyRQPMQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.18";
        hash = "sha512-L0ukahE5lLisbMxyoxWCQBpKY117P1oFQgoZ1hQQtch9C57V+aE2NVZWlw3CS9qZbgXNQM1V82KufKeQZuDr0w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.18";
        hash = "sha512-v6qCvouvUtfA0DE4RNA3PrzogS4ONteXRY1fwGOSsLkl+KxPgqVdthRe3+gR2Lfvm9gTCotQ45apZtN40/lT/w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.18";
        hash = "sha512-m/4V22FwHydLgj8uxm6N+ppVNg9Kg7RoRkjwYoJjn0KtIPNUMCIRzIuu4none/69xsnin4f8b04WmWeFVwSyEw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.18";
        hash = "sha512-GQEbT3ZAZ1U7e0D6ITED9vCmWJFrV0cmS4+SIahtgXi0TZCZJzEwYoykqOPo6RoAOnXhfCeuvkjc228TguaFTg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-J/yYUDTa8pO11iHli+ABrIGtmy76Ku8I1zGslng16xgtlxZfX1bbemPDh4/2oV85h88ls0MAWfCb+kpcdsDCfQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-dnpvnbwteEY5YMS5usz2NJsvhvYI9qjKGrGHDQ1uoYZg6N32k9kEPS1aSRyeDtlGkbb8Mn9k+fCseXnVOyAsNA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-gzBgLBbh8ZNmUtFiHa8I2fOOBkl1WiOC2iq8bYX/eVAd2n4h3wOxNG4+3tt1Ra1f58JbYASBG/sXqdMBliMI3A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-Ddoy/MJj1S0xT09GAbrZnwSEUI7gQRcEOil3XaYA9pWnp8OXAi/of7GGZbbbD2HWGUtsSHmfmiRlRoXPhcFOEQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.18";
        hash = "sha512-ZWRx5vfKRPpQEzwJpaQ6MZQ7JW9y7Jj2MvjKfLmmwATzG7z4PHhmM9QsNygmSrqsF24hJVjdDhxGs6vEcPXA9Q==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.18";
        hash = "sha512-E6fXd/FU8IHuPlyuv0cfvr+8q7QJe0uF6u5lxU2EsCd3Z6qKxXS97w0U9o7OdriEGBC6oiwyzVq25oLQDvrbog==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.18";
        hash = "sha512-dA97YbdoMd1HlkZ6LISmioAJHhG9QlzGtVfaAYwLHvMFDvlulS3DXMmSR+fRrP3h+A9sNR5nflpkIJ4khotAbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.18";
        hash = "sha512-KWXB2BApvTlT4Osl1KrDTA6pVUdc7cYbWcLEA+MrcQzwq1az0aLtp7cBVvTHGae7Zq18CvxBrMTQcyXTY2RHEA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-3eBkAXIr+RBbCEMZJGU0S6Owg2XFaDC6fpNENWG+0wBrw7lpLNqTUUtcTY7xA1IHLD4p0ffYc14QauObnL+mzg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-NQrl3gWAuxIvq6Me5taCyOrGSjldQg4WGcmXiS4qnh/js+GvpG77XUNltfzWy7EamgCjjYIi3S6fHsxntxsMXw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-KVwSnqrat6U8XT/aWXBwUlQB5uwJTwGV6TX0P3BPfMb01B99QvX0wuw/Rf57WSrjvlT5oG9gBFClBt2jIh3s/w==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-ziuMoQo2E6qi8vRnire+pGCVES3HCxEVSE0ExXHeHdf20rQzO6Xv40Dm+bfDNvMzJLU9WDRDJ8OgULiB9XYn/g==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.18";
        hash = "sha512-0E2hSPVKTdkeBHMpeRHYV45C1Vm5UppTb/YX6OV3y7sB7U9tTHRu6soC50Hnxv7013Umzle8g1dqFWzGFa/5PQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.18";
        hash = "sha512-tLz7EUFrCQq0obc2bVv7Qm0OLQYA9gAM9NUEGx3N1wtQ6+0yQg+Sy7UIa0LWCj28JBw7QU7yH3JaUWfVVtzwTg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.18";
        hash = "sha512-Txko4ZcsHAiOF+o4uYuUWjkP42/abwYmhRPh5h0k7WiwpQ5InU6vuqvub0aBj9Tbgc7ULOZXYxwhqSsyT80x8g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-5IMZXp65TGVCv5cWzE+sa4DjOZ7lxDb3/ojumL7dqtZTKXBXxDKKEXWXQXkndJduTbTWLxEOJ3qNZK9oZRkLEA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-OQa/DFd2MfWgVP6ffNY8LPptJUgd5cIa85WWF5vvzQu3N7b6ZHodf0FugfXrzr/OE1tNVXc2MgNE6gYu+cuVTQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-ymW//M4dvkpsR2olamF7EDdXA8ssjIQGKDopMVM9SU4piAiFKzrk58OcJzMU5+r0R10ClZWg7UR5BCYVe9apDw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-dGZg9b54bEc3VTiYB/2kQvSjEIs/Q9zAhbRqI453gl/O1alVglJ8c4Ui6LFTVwrGgcZO5PLGvXHa4m6NrOeu2A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.18";
        hash = "sha512-+rw1VG6eVUjppOeH/9JPaNwtjm/nEAZFrRTWjcNkvWalG7yeTuhNeyuc77WYvc4I87yJBOvLB/dI2/QYNDIssA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.18";
        hash = "sha512-iE4MEnboqeUM4A/hd0jAvTGO50j+gziJqszz9PUhF4f3VgsUH80H78MEhYU34BsF3gBuKMMW3luywrPws9vCeA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.18";
        hash = "sha512-FT0tpzuEiQxsi5zyNILgW9rcmoI+KzvFtzEHtxha7X+WYTuVTOHD+itYUT1gpEgECHgPonkD9FUSjNfWPLEvPA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.18";
        hash = "sha512-lRBru61Iknwa479ALoKT5S2ra5F/LbFrp4i7BZFwBltB5NAA1AVF7rTxlWaAyZ0wpypr8EsyCWepUnzg62ewlw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.18";
        hash = "sha512-ypgDsw9Edi/5pooVknF1KuQztaFe0vxAXoGqPeyqSJyzgjEy+VDsiFOwQ3jVAo708H52Bde3ep31mGFmKPwl6Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.18";
        hash = "sha512-ZbjYmXt0IS5AfsxnsZ6tLT5mgV17N3ooOKXzVluwuEnQhxioH/6Qo6Dd6ou6bQiUvALia/lyXDOX0PwrzFgz6g==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.18";
        hash = "sha512-AhPxu82INmXyVO2hlWUpfiZbREsnHzTZrGfpyOU155loE9YgOuP9WEB4SgRLMtgpj/1ltBnUkIYedpM6jT9wjQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.18";
        hash = "sha512-c+yHxGyXN312TLyqPLiCE2LuRl2HeZ3Z37b2drwKgy6WEbuzKR4/hhsa26ABQqb05HRe0OKYcE6inS0qyNRoBw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.18";
        hash = "sha512-nNz4TK0BsQA75HnRAfhoaelmRE96RmzD1Hk6ysRXEuAWm/cLQOHaY9Urrlb+cKw/4m5AR8OplEwlYhAKRQnXDw==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.18";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.18";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-arm.tar.gz";
        hash = "sha512-HCLFwQNsUTYWZa/7cVTiSK7uvDYegM8C0uSrJ/e+jhn7TKHmn0OiuWGtx72QBW9vtWrrbrUHqHpBv7plPT8A8g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-arm64.tar.gz";
        hash = "sha512-mXzjYYBQP71N2G7UO1M/YYvh23zxcPUA0NEviZrf8i5bdxSUKqJRPuzmwSIkdhwUP7yR1ul9g8zK7YqBHrzYNQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-x64.tar.gz";
        hash = "sha512-iW6cq3w+pThMF05+LP+uPH+PntXW0rdDS1orDcPwK2Ef+GaPXXDAs1ampdhaKP5AdWzzVrFo0DBjcNoRZGtLIw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-musl-arm.tar.gz";
        hash = "sha512-yneAoDyatUgLn5KqnkkUgsrxnhiMO28lXlVRiSM6cZdOWNl+lJs7nSExrxaHAvF/WSkFRdoNk4Wy26xBDfdzTg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-musl-arm64.tar.gz";
        hash = "sha512-5qVB3jfi9HUAMABd5HW+7T45RPFfzYeKIUFvC5Un/OoUJKEhRWTqltm5S90zfgsAm38NMXBBBtLLiiMHNJUWZg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-linux-musl-x64.tar.gz";
        hash = "sha512-ZwfiXAuiV0K2j915SJftmKl9PPDEf/Milh8eP66L6YMiDpMLK8l065DGdJ0SzHYWbyq+Ry4LxEkhOK0RlN3TMg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-osx-arm64.tar.gz";
        hash = "sha512-T8pecG6i7B8GIt3a8SB3axtvL4XaxP8lyeUgPXWevE05Gk8Zc8EWYHhQJZzWPM4LtlRMuldSvZYq7BX3cQlhww==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.18/aspnetcore-runtime-8.0.18-osx-x64.tar.gz";
        hash = "sha512-xSIM7l7VpquZ24ec3HaxTRORBBNBwbIgRXCCBVDgwRkqo7/g4pU4OmkvZmbYXoYsZuWfF0fTynBOfhp/0Qx7RA==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.18";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-arm.tar.gz";
        hash = "sha512-kMxr02jsGrcl6egU6ZjDeByl32figzNFwFLtFxBiA7oeiM8CBqx8M/gT0D8xZFQEAtvLi+DTa9j77847LfBNTw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-arm64.tar.gz";
        hash = "sha512-fZagkKLlbzk/wyOF2hRRU12/Tk2Y7cGSsa5uoNCX5megWYKMfyN1+sa8J1+Nsdg/XNJipx/vbCgkHKriIpuqPw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-x64.tar.gz";
        hash = "sha512-FddUoByTGD6pi9YI8mkRk8hvKE7H/t38gQ+tkZ4ve6INQeHeRXifwdmsn82L6C1Jy4/kxHHeyJL5EnL+ouU/CA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-musl-arm.tar.gz";
        hash = "sha512-HFrhWlR+KZEHHzjmn/xwbpP5PCQbvLGJGBV6QttSjV5aHz7eAenPDRcbHzJcvebdN0fELGsLpFvFX5AqlwWkfQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-musl-arm64.tar.gz";
        hash = "sha512-PK/rE2xt8uRfad+mQUZgE/Uacw8VQ1SQGwVVJsRNvVHX4AFyaVHRUkU4cGZk56pu9eRRU43bqDF5icIpvoxIWA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-linux-musl-x64.tar.gz";
        hash = "sha512-qgLhilNFk5IrTwbv0LRHpwFwrXj06jGwiSOSIEPa4bdYAduLBLSdj+JOys9GyFQbsrFGYphgjGRhLpTk0OU2DQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-osx-arm64.tar.gz";
        hash = "sha512-6nk+JQO0Ds9W0738Dfwh/ImeGKlBRLu1D/ZLPcHzg5KnvS9X9hFw7POv5zO7oPwkxdDgAFe33y2o8m/X9pYSyQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.18/dotnet-runtime-8.0.18-osx-x64.tar.gz";
        hash = "sha512-ytzK1CKQwAspFPXxRvZ3eUb5Baf+31WMEE7G7GrDHi407ABp/e7cNX9aaRZeoxvsEZPwJNcG6Shmox7ap02e+w==";
      };
    };
  };

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.412";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-arm.tar.gz";
        hash = "sha512-J1MURAy/OKN5MRz60BETV5fg1mKKAeD5TQiJ9NsNHFzZ90a4R/WlHSrVpdJpz652lFw/BJfZ4VjMiLr51ZTQoQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-arm64.tar.gz";
        hash = "sha512-BUnSREexHUu0IGyBL10RO/bM45MpmQlNXrwRjdDPldqFrtT7es6UKqaDs5cKPCU+fbneACAnxBiFT4g1SHn81w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-x64.tar.gz";
        hash = "sha512-SAYuEiIiJIRcs/ki2ZHHjAZKHdBW5LHIkrYG4konwfVBPcQiIc3PQiXcth4+4CXSp3FZAGaHAJEwM1rFFfWTBA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-musl-arm.tar.gz";
        hash = "sha512-z79sRZmduJcaJq4n02IJEMpd+2KpdfFrWhCq2FxhGd5tkJNH4W/bKrQ5YwFzeSQMT3wEa+gbt1Gqkk2dJdmJeg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-musl-arm64.tar.gz";
        hash = "sha512-5oOgjDcN4vKWQ/o3Ia2hX2cJeEAuNmJ0G8JW/yjLy2cqNUase6qCUhyny8ol11JzPISQdAqztK4FX746VH1Stg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-linux-musl-x64.tar.gz";
        hash = "sha512-w9+70mppmw73bexLYb57MJLdJbJs68ErAgL6YUb9g2dgzBolGilkCRUHvULZZyLN91iLNmJhyn1+qehJs8zfGw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-osx-arm64.tar.gz";
        hash = "sha512-ECe1BpxAO0QczPt/wPglhKpYIgUphhocTyrpHG8wsZ6oSSnedljekvXMuldQT7bisop2A3biAyechPqzVLnxFg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.412/dotnet-sdk-8.0.412-osx-x64.tar.gz";
        hash = "sha512-AFCi6otRDtq2pKQOfkW5NaZRunWkcd4ea9Go8bQ4AqouARVn1L5o10SAe3xXwKVT0IWNFn6gpTKXHRAU5aP8qA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_3xx = buildNetSdk {
    version = "8.0.315";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-arm.tar.gz";
        hash = "sha512-8QeLKXetMCnZHZFhnsJz6qSJYrTFi89/t9CrkdAsnWUeRxHGAY0gJuqlgT5LlDelB2dT4ZcaeDPM0blKKnHO+Q==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-arm64.tar.gz";
        hash = "sha512-OW6R8OlLUUWOkZMgi4dzlJ/CmXSk6neyrT1AQxq8eHF2rA2i42H/O0UAgjb1NzIVt3USiw7oNQM+L+4V/RTphQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-x64.tar.gz";
        hash = "sha512-USH25zHSrn0TNWKTKfo+sIyLLhvW8Q5tSlS4+D9JouQ6tU+k4NCH2VUSzzxtWWUf6mOBmb/dNGhN3IQ3kFE8Tg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-musl-arm.tar.gz";
        hash = "sha512-SnaDa5guhz0TQytx/BEMn13z7gAcd7D39fhlx2wABs+cRKeu9RryGJh2JtycJQ9BrQiC8/tAYWVipTBDHnZ+jQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-musl-arm64.tar.gz";
        hash = "sha512-NytafoFGcI9BBRR2xXDsSrydWVHVAOg/OP/8aW4lj3Ka15SaeF99q2pX3Y+H2UoYq1+nCjCLhyVPtOnZ/5lVQw==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-linux-musl-x64.tar.gz";
        hash = "sha512-T8gmYdg1WcU9+TRaVaG5TrVD7Xcxyga+jpWWw14Ms+PtGf29i0ohYtNDh9jLAjMezAa5FmsrwzBNNnZk/tBYrA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-osx-arm64.tar.gz";
        hash = "sha512-9T7DnkacO6Cqsh3lzTz0JiFNCiL3zFN3nWlz28H3PtbIAOBgdiS6Y/OvaR7F3NNXH+f2KUYAFAPsXzl6AOqOuQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.315/dotnet-sdk-8.0.315-osx-x64.tar.gz";
        hash = "sha512-anHc1Ui4pjLK/pWKon2zELU04ALg9vNUpfrkb0JXX6TjFVU0MYVK0VVrZR5ybglSKVE/qSsLgMuErwxH6OXJmA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.118";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-arm.tar.gz";
        hash = "sha512-MNxznkN2vwScF/GKRDE8noX7TOC4JuTIkKpdsDANghswWPOuXPrhfDeBZ473YQQvjI9m+TEbbIdVAQ9juJGntw==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-arm64.tar.gz";
        hash = "sha512-wgnYjvV4QLc2Dnsoylwimz/I/YLT4bDimXMOm4Aav7Slzm9k3GZ9WGbGJEuv4QtKveakv/czvk1M4HkcvexVnA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-x64.tar.gz";
        hash = "sha512-2vL4BS3M6u0AWW0fiHsxsZky6m/GRHcAb63X69tWW2zKrawrLDjVe6WNbhVrcq2wlKc1CuodUR53rZZ1SDIaaw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-musl-arm.tar.gz";
        hash = "sha512-WGhhR5827n4KU7+RS+t6weMYVfHnJmPR1+//JKw47gXMlU19Tv2B4y/oyz2/AINyXkwQ3lr3ajCmlCQxhKWKIA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-musl-arm64.tar.gz";
        hash = "sha512-B2IERPKgrg21B431M6ryjmVZWqYoJBo9bScTPzqeDhlVLNr6TW3EpBfCejTZfqpxUv6TCsOsgS7rYpdDAnT4Zg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-linux-musl-x64.tar.gz";
        hash = "sha512-6zHGhF86H/XMx7U37cCOtnRRBIUPd+Z1+otVN4A5y7/e3Oy1olcUiJAO2KUTimTj+3MMMFGBbzZqSPmPAKoqMQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-osx-arm64.tar.gz";
        hash = "sha512-9oshklflApdjCbtzeUtn8p3ODmlfQFRL0SgnTWQ1yW8TvHv7MolhnNxSuBy3GWA575xRfGsyKHMqo9SR9cy8tg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.118/dotnet-sdk-8.0.118-osx-x64.tar.gz";
        hash = "sha512-cXeLlCj2s7Mf2pHlhaIv7aC5VSI77PWQB2d0bpgQIru2MqJrHru9ImaGdFU3aLvbXTJMP1toxwnAYW47jSAVvw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0 = sdk_8_0_4xx;
}
